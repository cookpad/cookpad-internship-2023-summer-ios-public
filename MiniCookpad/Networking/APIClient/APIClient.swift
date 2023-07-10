import Foundation

protocol APIClient {
    func send<Request: APIRequest>(request: Request) async throws -> Request.Response
}

enum APIClientError: Error {
    case connectionError(Error)
    case invalidURLResponse(URLResponse)
    case requestError(APIRequestError)
    case responseError(APIResponseError)
}

enum APIResponseError: Error {
    case serializationError(Error)
    case serviceUnavailable(statusCode: Int, responseBody: Data) // HTTP 5XX
    case unacceptableStatusCode(statusCode: Int, responseBody: Data) // HTTP 4XX
}

final class MiniCookpadAPIClient: APIClient {
    private let session: URLSession = {
        return URLSession(configuration: .default)
    }()

    func send<Request: APIRequest>(request: Request) async throws -> Request.Response {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.makeURLRequest()
        } catch {
            let requestError = (error as? APIRequestError) ?? .unknownError(error)
            throw APIClientError.requestError(requestError)
        }

        let data: Data
        let urlResponse: URLResponse
        do {
            #if DEBUG
            print("[API Request] \(urlRequest.debugDescription)")
            #endif
            (data, urlResponse) = try await session.data(for: urlRequest)
        } catch {
            throw APIClientError.connectionError(error)
        }

        guard let httpURLResponse = (urlResponse as? HTTPURLResponse) else {
            throw APIClientError.invalidURLResponse(urlResponse)
        }

        #if DEBUG
        print("[API Response] \(urlRequest.debugDescription) HTTP status code: \(httpURLResponse.statusCode)")
        #endif

        let statusCode = httpURLResponse.statusCode
        if !(200 ..< 300).contains(statusCode) {
            if statusCode >= 500 {
                throw APIClientError.responseError(.serviceUnavailable(statusCode: statusCode, responseBody: data))
            } else {
                throw APIClientError.responseError(.unacceptableStatusCode(statusCode: statusCode, responseBody: data))
            }
        }

        let response: Request.Response
        do {
            response = try request.makeResponse(from: data, urlResponse: httpURLResponse)
        } catch {
            throw APIClientError.responseError(APIResponseError.serializationError(error))
        }

        return response
    }
}

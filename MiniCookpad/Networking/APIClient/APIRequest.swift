import Foundation

protocol APIRequest {
    associatedtype Response: Decodable

    var url: URL { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var body: [String: Any] { get }

    func makeURLRequest() throws -> URLRequest
    func makeResponse(from data: Data, urlResponse: HTTPURLResponse) throws -> Response
}

enum APIRequestError: Error {
    case serializationError(Error)
    case invalidURL(description: String)
    case unknownError(Error)
}

protocol APIRequestBodyContent {
    var contentType: String { get }
    func makeBody() throws -> Data?
}

public struct JSONObjectAPIRequestBodyContent: APIRequestBodyContent {
    public let contentType = "application/json"
    public var jsonObject: [String: Any]

    public init(jsonObject: [String: Any]) {
        self.jsonObject = jsonObject
    }
    
    public func makeBody() throws -> Data? {
        return try JSONSerialization.data(withJSONObject: jsonObject)
    }
}

extension APIRequest {
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var body: [String: Any] { [:] }
}

extension APIRequest {
    func makeURLRequest() throws -> URLRequest {
        var url = self.url
        var headerFields: [String : String] = [:]

        var httpBody: Data?
        if method.prefersQueryParameters {
            if !queryItems.isEmpty {
                guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    throw APIRequestError.invalidURL(description: "Could not initialize URLComponents from url")
                }
                components.queryItems = queryItems
                guard let updatedURL = components.url else {
                    throw APIRequestError.invalidURL(description: "Could not convert URLComponents to a URL")
                }
                url = updatedURL
            }
        } else {
            if !body.isEmpty {
                let bodyContent = JSONObjectAPIRequestBodyContent(jsonObject: body)
                headerFields["Content-Type"] = bodyContent.contentType
                do {
                    httpBody = try bodyContent.makeBody()
                } catch {
                    throw APIRequestError.serializationError(error)
                }
            }
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = httpBody
        if !headerFields.isEmpty {
            urlRequest.allHTTPHeaderFields = headerFields
        }

        return urlRequest
    }
}

extension APIRequest {
    func makeResponse(from data: Data, urlResponse: HTTPURLResponse) throws -> Response {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Response.self, from: data)
    }
}

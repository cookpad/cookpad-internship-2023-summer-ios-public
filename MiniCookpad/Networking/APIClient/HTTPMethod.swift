enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"

    var prefersQueryParameters: Bool {
        switch self {
        case .get, .delete:
            return true

        default:
            return false
        }
    }
}

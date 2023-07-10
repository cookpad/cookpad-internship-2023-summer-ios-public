import Foundation

struct GetRecipeListRequest: APIRequest {
    typealias Response = GetRecipeListResponse
    let url = URL(string: "https://localhost:3001/recipes")!
    let method: HTTPMethod = .get
    let limit = 10

    var queryItems: [URLQueryItem] {
        let items: [URLQueryItem] = [.init(name: "limit", value: String(limit))]
        return items
    }
}

struct GetRecipeListResponse: Decodable {
    struct Recipe: Decodable {
        struct User: Decodable {
            let name: String
        }

        struct Ingredient: Decodable {
            let name: String
        }

        let id: Int64
        let title: String
        let description: String
        let imageUrl: String?
        let user: User
        let ingredients: [Ingredient]
    }

    let recipes: [Recipe]
}

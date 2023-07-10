import Foundation

struct GetRecipeHashtagsRequest: APIRequest {
    typealias Response = GetRecipeHashtagsResponse
    let recipeIds: [Int64]
    let url = URL(string: "https://localhost:3002/recipe_hashtags")!
    let method: HTTPMethod = .get
    let limit = 10

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [.init(name: "hashtag_limit_per_recipe", value: String(limit))]
        if recipeIds.isEmpty {
            fatalError("must specify at least one recipeId to request")
        } else {
            items.append(.init(name: "recipe_ids", value: recipeIds.map(String.init).joined(separator: ",")))
        }
        return items
    }
}

struct GetRecipeHashtagsResponse: Decodable {
    struct RecipeHashtag: Decodable {
        let recipeId: Int64
        let hashtags: [Hashtag]
    }

    let recipeHashtags: [RecipeHashtag]
}

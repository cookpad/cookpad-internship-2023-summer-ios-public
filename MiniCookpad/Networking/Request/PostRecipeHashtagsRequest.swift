import Foundation

struct PostRecipeHashtagsRequest: APIRequest {
    typealias Response = PostRecipeListResponse
    let url = URL(string: "https://localhost:3002/hashtags")!
    let method: HTTPMethod = .post
    let recipeID: Int64
    let value: String
    // Try: body に recipe_id と value を追加してリクエストを送る
    var body: [String: Any] {
        [
            "recipe_id": recipeID,
            "value": value,
        ]
    }
}

struct PostRecipeListResponse: Decodable {
    let hashtags: [Hashtag]
}

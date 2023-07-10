import Foundation

final class StubAPIClient: APIClient {
    private let fixtureLoader = FixtureLoader()

    func send<Request: APIRequest>(request: Request) async throws -> Request.Response {
        try await Task.sleep(nanoseconds: 1000 * 1000 * 500)

        switch request {
        case is GetRecipeListRequest:
            return fixtureLoader.decodeObject(fromJSONNamed: "get_recipe_list")
        case is GetRecipeHashtagsRequest:
            let recipeHashtagsRequest = request as! GetRecipeHashtagsRequest
            if recipeHashtagsRequest.recipeIds.count == 1 {
                // レシピ詳細
                return fixtureLoader.decodeObject(fromJSONNamed: "get_recipe_detail_hashtags")
            } else {
                return fixtureLoader.decodeObject(fromJSONNamed: "get_recipe_list_hashtags")
            }
        case is GetRecipeDetailRequest:
            return fixtureLoader.decodeObject(fromJSONNamed: "get_recipe_detail")
        case is PostRecipeHashtagsRequest:
            return fixtureLoader.decodeObject(fromJSONNamed: "post_recipe_hashtags")
        default:
            throw APIClientError.requestError(.invalidURL(description: "No matching stubs found for \(request)"))
        }
    }
}

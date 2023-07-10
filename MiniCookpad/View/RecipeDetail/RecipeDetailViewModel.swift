import Combine

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    private let recipeID: Int64
    @Published var recipeDetailItem: RecipeDetailItem?

    init(recipeID: Int64, recipeDetailItem: RecipeDetailItem? = nil) {
        self.recipeID = recipeID
        self.recipeDetailItem = recipeDetailItem
    }

    func request() async {
        do {
            async let recipeDetail = apiClient.send(request: GetRecipeDetailRequest(recipeId: recipeID))
            async let hashtagsResponse = apiClient.send(request: GetRecipeHashtagsRequest(recipeIds: [recipeID]))
            recipeDetailItem = try await RecipeDetailItem(recipe: recipeDetail.recipe, hashtags: hashtagsResponse.recipeHashtags.flatMap { $0.hashtags })
        } catch {
            print(error)
        }
    }
}

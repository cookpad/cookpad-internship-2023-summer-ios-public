import Combine

@MainActor
final class RecipeListViewModel: ObservableObject {
    @Published var items: [RecipeListItem] = []
    
    func request() async {
        do {
            let recipeListResponse = try await apiClient.send(request: GetRecipeListRequest())
            let recipeHashtagsResponse = try await apiClient.send(request: GetRecipeHashtagsRequest(recipeIds: recipeListResponse.recipes.map(\.id)))
            
            var newItems: [RecipeListItem] = []
            for (recipe, recipeHashtags) in zip(recipeListResponse.recipes, recipeHashtagsResponse.recipeHashtags) {
                if recipe.id != recipeHashtags.recipeId {
                    fatalError("今回は必ずrecipe_idを送った順にレシピに紐付くハッシュタグがAPIから返ってくることが保証されているとして進める")
                }
                newItems.append(.init(recipe: recipe, hashtags: recipeHashtags.hashtags))
            }
            
            items = newItems
        } catch {
            print(error)
        }
    }
}

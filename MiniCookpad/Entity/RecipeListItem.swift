import Foundation

struct RecipeListItem: Identifiable {
    var id: Int64 { recipe.id }
    let recipe: GetRecipeListResponse.Recipe
    let hashtags: [Hashtag]
}

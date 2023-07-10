import Foundation

struct RecipeListSampleDataProvider {
    static func makeRecipeListSampleData() -> [RecipeListItem] {
        let fixtureLoader = FixtureLoader()
        let recipesRes: GetRecipeListResponse = fixtureLoader.decodeObject(fromJSONNamed: "get_recipe_list")
        let hashtagsRes: GetRecipeHashtagsResponse = fixtureLoader.decodeObject(fromJSONNamed: "get_recipe_list_hashtags")

        var newItems: [RecipeListItem] = []
        for (recipe, recipeHastags) in zip(recipesRes.recipes, hashtagsRes.recipeHashtags) {
            assert(recipe.id == recipeHastags.recipeId)
            newItems.append(.init(recipe: recipe, hashtags: recipeHastags.hashtags))
        }
        return newItems
    }
}

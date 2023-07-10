import Foundation

struct GetRecipeDetailRequest: APIRequest {
    typealias Response = GetRecipeDetailResponse
    let recipeId: Int64
    let method: HTTPMethod = .get

    var url: URL {
        .init(string: "https://localhost:3001/recipes/\(recipeId)")!
    }
}

struct GetRecipeDetailResponse: Decodable {
    struct Recipe: Decodable {
        struct User: Decodable {
            let name: String
            let imageUrl: String?
        }

        struct Ingredient: Decodable, Identifiable {
            let id: Int64
            let name: String
            let quantity: String?
        }

        struct Step: Decodable, Identifiable {
            let id: Int64
            let memo: String
            let imageUrl: String?
        }

        let id: Int64
        let title: String
        let description: String
        let imageUrl: String?
        let user: User
        let ingredients: [Ingredient]
        let steps: [Step]

        static let mock = Recipe(
            id: 1,
            title: "鶏ハムにおかずラー油でなんちゃって口水鶏",
            description: "全く口水鶏ではないけど、おいしいよ",
            imageUrl: nil,
            user: .init(name: "クックモリシン", imageUrl: nil),
            ingredients: [
                .init(id: 1, name: "鶏ハム レシピID:7251614", quantity: "おこのみ"),
                .init(id: 2, name: "おかずラー油", quantity: "おこのみ"),
            ],
            steps: [
                .init(id: 1, memo: "鶏ハムにおかずラー油をかける", imageUrl: nil),
            ]
        )
    }

    let recipe: Recipe
}

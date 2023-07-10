import SwiftUI

struct RecipeListRow: View {
    let item: RecipeListItem

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: item.recipe.imageUrl ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .cornerRadius(4)
            VStack(alignment: .leading, spacing: 6) {
                Text(item.recipe.title)
                    .font(.headline)
                    .foregroundColor(.recipeTitle)
                Text("by \(item.recipe.user.name)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(item.recipe.ingredients.map(\.name).joined(separator: ", "))
                    .lineLimit(1)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(item.hashtags.map({ "#\($0.name)" }).joined(separator: " "))
                    .lineLimit(1)
                    .font(.caption2)
                    .foregroundColor(.black)
            }
        }
    }
}

struct RecipeListRow_Previews: PreviewProvider {
    static let item = RecipeListItem(
        recipe: .init(
            id: 1,
            title: "ホワイトソースのパスタ",
            description: "おもてなし・パーティに最適♪",
            imageUrl: nil,
            user: .init(name: "クックサマーインターン"),
            ingredients: [
                "芽キャベツ",
                "生ハム",
                "ホワイトソース",
                "パスタ",
                "塩"
            ].map(GetRecipeListResponse.Recipe.Ingredient.init)
        ),
        hashtags: [
            .init(id: 1, name: "パーティー料理"),
            .init(id: 2, name: "パーティーに"),
            .init(id: 3, name: "おもてなし"),
        ]
    )

    static var previews: some View {
        RecipeListRow(item: item)
    }
}

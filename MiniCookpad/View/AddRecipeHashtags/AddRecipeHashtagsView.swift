import SwiftUI

struct AddRecipeHashtagsView: View {
    let item: RecipeDetailItem
    var hashtagsCreatedHandler: (() -> Void)?
    @State private var hashtagsText: String = ""
    @State private var showHashtagsAddedAlert: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                AsyncImage(url: URL(string: item.recipe.imageUrl ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .scaledToFill()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.smoke, lineWidth: 1))
                .frame(width: 100, height: 100)

                Text(item.recipe.title)
                    .font(.headline)
                    .foregroundColor(.recipeTitle)

                Text("by \(item.recipe.user.name)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer().frame(height: 24)

            TextField("#タグ1　#タグ2(スペース区切り)", text: $hashtagsText)
                .frame(minWidth: 200)
                .padding(12)
                .background(Color.smoke)
                .cornerRadius(4)

            Spacer().frame(height: 60)

            Button(action: {
                // Try: ハッシュタグを追加するPOSTリクエストを送る
                // 軽量なリクエストでありコードを複雑にしないため、キャンセルなどについては考慮しない
                Task {
                    do {
                        let response = try await apiClient.send(request: PostRecipeHashtagsRequest(recipeID: item.recipe.id, value: trimmedHashtags(hashtagsText)))
                        if !response.hashtags.isEmpty {
                            // Try: ボタンタップ時にアラートを表示する
                            showHashtagsAddedAlert = true
                            // Try: POSTリクエストのレスポンスのハッシュタグをRecipeDetailViewに反映する
                            hashtagsCreatedHandler?()
                        }
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Text("ハッシュタグを追加する")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
            })
        }
        .frame(maxWidth: 320)
        .offset(y: -100)
        .navigationTitle(Text("ハッシュタグ追加"))
        // Try: アラートを表示して、「OK」を押したらAddRecipeHashtagsViewを閉じる
        .alert(
            "ハッシュタグを追加しました",
            isPresented: $showHashtagsAddedAlert,
            presenting: hashtagsText,
            actions: { _ in
                Button(role: .none) {
                    showHashtagsAddedAlert = false
                    // RecipeDetailView から showAddRecipeHashtags を false にする closure をこの View に渡してそれをここで実行する方法でもOK
                    dismiss()
                } label: {
                    Text("OK")
                }
            }
        )
    }

    private func trimmedHashtags(_ text: String) -> String {
        text.replacingOccurrences(of: "　", with: " ")
            .replacingOccurrences(of: "＃", with: "#")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct AddRecipeHashtagsView_Previews: PreviewProvider {
    static let item = RecipeDetailItem(
        recipe: .init(
            id: 1,
            title: "ホワイトソースのパスタ",
            description: "おもてなし・パーティに最適♪",
            imageUrl: nil,
            user: .init(name: "クックサマーインターン", imageUrl: nil),
            ingredients: [],
            steps: []
        ),
        hashtags: [
            .init(id: 1, name: "パーティー料理"),
            .init(id: 2, name: "パーティーに"),
            .init(id: 3, name: "おもてなし"),
        ]
    )

    static var previews: some View {
        AddRecipeHashtagsView(item: item)
    }
}

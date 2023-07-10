import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()

    var body: some View {
        List(viewModel.items) { item in
            NavigationLink {
                RecipeDetailView(viewModel: .init(recipeID: item.recipe.id))
            } label: {
                RecipeListRow(item: item)
            }
        }
        .listStyle(.plain)
        .task {
            await viewModel.request()
        }
        .navigationTitle("レシピ一覧")
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeListView()
        }
    }
}

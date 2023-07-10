import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel
    @State private var showAddRecipeHashtags: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                placeholderImageView(imageURL: URL(string: viewModel.recipeDetailItem?.recipe.imageUrl ?? ""))
                    .aspectRatio(1.0, contentMode: .fill)

                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.recipeDetailItem?.recipe.title ?? "")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.recipeTitle)
                    HStack {
                        placeholderImageView(imageURL: URL(string: viewModel.recipeDetailItem?.recipe.user.imageUrl ?? ""))
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text(viewModel.recipeDetailItem?.recipe.user.name ?? "")
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                    if let hashtags = viewModel.recipeDetailItem?.hashtags, !hashtags.isEmpty {
                        Text(hashtags.compactMap { "#\($0.name)" }.joined(separator: " "))
                            .lineLimit(2)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.smoke)
                            .cornerRadius(6)
                    }
                    Text(viewModel.recipeDetailItem?.recipe.description ?? "")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 0) {
                    sectionHeader(title: "材料")
                        .padding(.leading, 16)
                    if let ingredients = viewModel.recipeDetailItem?.recipe.ingredients, !ingredients.isEmpty {
                        ForEach(Array((ingredients).enumerated()), id: \.offset) { offset, ingredient in
                            if ingredient.name.isEmpty {
                                EmptyView()
                            } else {
                                HStack(alignment: .center) {
                                    bodyText(ingredient.name)
                                    Spacer()
                                    bodyText(ingredient.quantity ?? "")
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(offset % 2 == 1 ? Color.white : Color.ivory)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    sectionHeader(title: "作り方")
                    if let steps = viewModel.recipeDetailItem?.recipe.steps, !steps.isEmpty {
                        ForEach(Array((steps).enumerated()), id: \.offset) { offset, step in
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(offset + 1)")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .background(Color.gray)
                                    .cornerRadius(4)
                                bodyText(step.memo)
                                if let imageURLString = step.imageUrl, let imageUrl = URL(string: imageURLString) {
                                    placeholderImageView(imageURL: imageUrl)
                                        .frame(width: 90, height: 90)
                                        .cornerRadius(4)
                                }
                            }
                            .padding(.vertical, 16)
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 16)
                Spacer()
            }
        }
        .task {
            await viewModel.request()
        }
        .navigationBarTitleDisplayMode(.inline)        
        .toolbar {
            if let recipeDetailItem = viewModel.recipeDetailItem {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddHashtagsButton(item: recipeDetailItem, showAddRecipeHashtags: $showAddRecipeHashtags)
                }
            }
        }
        .sheet(isPresented: $showAddRecipeHashtags) {
            if let recipeDetailItem = viewModel.recipeDetailItem {
                AddRecipeHashtagsView(
                    item: recipeDetailItem,
                    hashtagsCreatedHandler: {
                        Task {
                            await viewModel.request()
                        }
                    }
                )
            }
        }
    }

    @ViewBuilder
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.headline)
            .bold()
            .padding(.bottom, 16)
    }

    @ViewBuilder
    private func placeholderImageView(imageURL: URL?) -> some View {
        AsyncImage(url: imageURL) { image in
            image.resizable()
        } placeholder: {
            Color.gray
        }
    }

    @ViewBuilder
    private func bodyText(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .foregroundColor(.black)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(
            viewModel: RecipeDetailViewModel(
                recipeID: 1,
                recipeDetailItem: .init(
                    recipe: .mock,
                    hashtags: []
                )
            )
        )
    }
}

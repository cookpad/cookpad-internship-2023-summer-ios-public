import SwiftUI

let apiClient: APIClient = {
    if ProcessInfo.processInfo.isRunningForPreview || ProcessInfo.processInfo.useStubAPIClient {
        return StubAPIClient()
    } else {
        return MiniCookpadAPIClient()
    }
}()

@main
struct MiniCookpadApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipeListView()
            }
        }
    }
}

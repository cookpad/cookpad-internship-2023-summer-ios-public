import SwiftUI

struct AutoLoadingIndicator: View {
    let isFetching: Bool
    let didReachLast: Bool
    let loadMoreAction: () async -> Void

    var body: some View {
        switch (isFetching, didReachLast) {
        case (false, false):
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    Task { await loadMoreAction() }
                }
        case (true, _):
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
        case (false, true):
            EmptyView()
        }
    }
}

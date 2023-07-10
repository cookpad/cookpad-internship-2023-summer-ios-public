import Foundation

extension ProcessInfo {
    var isRunningForPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    var useStubAPIClient: Bool {
        environment["USE_STUB_API_CLIENT"] == "1"
    }
}

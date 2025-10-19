import SwiftUI

@main
struct WalkingAppApp: App {
    @StateObject private var routeStore = RouteStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(routeStore)
        }
    }
}

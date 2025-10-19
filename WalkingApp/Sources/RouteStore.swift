import Foundation

class RouteStore: ObservableObject {
    @Published var routes: [WalkRoute] {
        didSet {
            saveRoutes()
        }
    }

    private let userDefaultsKey = "savedRoutes"

    init() {
        self.routes = []
        loadRoutes()
    }

    func addRoute(_ route: WalkRoute) {
        // Add to the beginning of the array to show the newest first
        routes.insert(route, at: 0)
    }

    private func saveRoutes() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(routes)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Error saving routes: \(error.localizedDescription)")
        }
    }

    private func loadRoutes() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return
        }

        do {
            let decoder = JSONDecoder()
            let savedRoutes = try decoder.decode([WalkRoute].self, from: data)
            self.routes = savedRoutes
        } catch {
            print("Error loading routes: \(error.localizedDescription)")
        }
    }
}

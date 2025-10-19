import SwiftUI

struct RouteListView: View {
    @EnvironmentObject private var routeStore: RouteStore

    var body: some View {
        List(routeStore.routes) { route in
            NavigationLink(destination: RouteDetailView(route: route)) {
                VStack(alignment: .leading) {
                    Text("日付: \(route.date, formatter: dateFormatter)")
                    // In a future step, we could calculate and display the distance
                    Text("座標数: \(route.coordinates.count)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("過去のルート")
        .listStyle(InsetGroupedListStyle())
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

struct RouteListView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy store with sample data for the preview
        let store = RouteStore()
        store.addRoute(WalkRoute(coordinates: [
            CLLocationCoordinate2D(latitude: 35.681, longitude: 139.767),
            CLLocationCoordinate2D(latitude: 35.682, longitude: 139.768)
        ]))
        store.addRoute(WalkRoute(coordinates: [
            CLLocationCoordinate2D(latitude: 35.691, longitude: 139.777),
            CLLocationCoordinate2D(latitude: 35.692, longitude: 139.778)
        ]))

        return RouteListView()
            .environmentObject(store)
    }
}

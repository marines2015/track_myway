import SwiftUI
import MapKit

struct RouteDetailView: View {
    let route: WalkRoute
    @State private var region: MKCoordinateRegion

    init(route: WalkRoute) {
        self.route = route

        // Calculate the initial region to show the entire route
        let center = Self.calculateCenter(for: route.coordinates)
        let span = Self.calculateSpan(for: route.coordinates)
        _region = State(initialValue: MKCoordinateRegion(center: center, span: span))
    }

    var body: some View {
        MapView(region: $region, routeCoordinates: route.coordinates)
            .navigationTitle(route.date, formatter: dateFormatter)
            .ignoresSafeArea(.all)
    }

    // Helper function to calculate the center of the route
    private static func calculateCenter(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        guard !coordinates.isEmpty else {
            return CLLocationCoordinate2D(latitude: 35.681, longitude: 139.767) // Default
        }

        var minLat = coordinates.first!.latitude
        var maxLat = coordinates.first!.latitude
        var minLon = coordinates.first!.longitude
        var maxLon = coordinates.first!.longitude

        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }

        return CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
    }

    // Helper function to calculate the span to fit the route
    private static func calculateSpan(for coordinates: [CLLocationCoordinate2D]) -> MKCoordinateSpan {
        guard !coordinates.isEmpty else {
            return MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Default
        }

        var minLat = coordinates.first!.latitude
        var maxLat = coordinates.first!.latitude
        var minLon = coordinates.first!.longitude
        var maxLon = coordinates.first!.longitude

        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }

        // Add some padding to the span
        let latitudeDelta = (maxLat - minLat) * 1.4
        let longitudeDelta = (maxLon - minLon) * 1.4

        return MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

struct RouteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample route for the preview
        let sampleRoute = WalkRoute(coordinates: [
            CLLocationCoordinate2D(latitude: 35.681, longitude: 139.767),
            CLLocationCoordinate2D(latitude: 35.680, longitude: 139.768),
            CLLocationCoordinate2D(latitude: 35.681, longitude: 139.769),
            CLLocationCoordinate2D(latitude: 35.682, longitude: 139.768)
        ])

        NavigationView {
            RouteDetailView(route: sampleRoute)
        }
    }
}

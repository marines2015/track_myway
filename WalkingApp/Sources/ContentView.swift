import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject private var routeStore: RouteStore
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125), // Default to Tokyo Station
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var isTracking = false

    var body: some View {
        NavigationView {
            Group {
                if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                    ZStack(alignment: .bottom) {
                        MapView(region: $region, routeCoordinates: locationManager.routeCoordinates)
                            .ignoresSafeArea(.all)

                        HStack(spacing: 20) {
                            Button(action: {
                                isTracking.toggle()
                                if isTracking {
                                    locationManager.startTracking()
                                } else {
                                    locationManager.stopTracking()
                                    // Save the route when tracking stops
                                    if !locationManager.routeCoordinates.isEmpty {
                                        let newRoute = WalkRoute(coordinates: locationManager.routeCoordinates)
                                        routeStore.addRoute(newRoute)
                                        // Also reset the current line on the map
                                        locationManager.resetRoute()
                                    }
                                }
                            }) {
                                Text(isTracking ? "記録停止" : "記録開始")
                                    .font(.headline)
                                    .padding()
                                    .background(isTracking ? Color.red : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                            if !isTracking && !locationManager.routeCoordinates.isEmpty {
                                Button(action: {
                                    locationManager.resetRoute()
                                }) {
                                    Text("リセット")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    }
                } else {
                    VStack {
                        Text("位置情報へのアクセスを許可してください。")
                        Button("設定を開く") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
            }
            .onAppear {
                locationManager.requestLocationAuthorization()
            }
            .onChange(of: locationManager.location) { newLocation in
                if let coordinate = newLocation?.coordinate {
                    region.center = coordinate
                }
            }
            .navigationTitle("ウォーキングマップ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RouteListView()) {
                        Image(systemName: "list.bullet")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RouteStore())
    }
}

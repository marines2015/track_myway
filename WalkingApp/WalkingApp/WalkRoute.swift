import Foundation
import CoreLocation

struct WalkRoute: Codable, Identifiable {
    let id: UUID
    let coordinates: [CLLocationCoordinate2D]
    let date: Date

    // CLLocationCoordinate2D is not directly Codable. We need to provide custom coding.
    enum CodingKeys: String, CodingKey {
        case id, date, latitudes, longitudes
    }

    init(id: UUID = UUID(), coordinates: [CLLocationCoordinate2D], date: Date = Date()) {
        self.id = id
        self.coordinates = coordinates
        self.date = date
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        try container.encode(latitudes, forKey: .latitudes)
        try container.encode(longitudes, forKey: .longitudes)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        let latitudes = try container.decode([CLLocationDegrees].self, forKey: .latitudes)
        let longitudes = try container.decode([CLLocationDegrees].self, forKey: .longitudes)
        coordinates = zip(latitudes, longitudes).map(CLLocationCoordinate2D.init)
    }
}

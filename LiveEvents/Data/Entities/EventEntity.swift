//

import DateHelper
import Foundation

struct EventEntity: Decodable {
    let identifier: Int
    let title: String?
    let performers: [PerformerEntity]?
    let venue: VenueEntity?
    let dateTime: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title = "title"
        case performers = "performers"
        case venue = "venue"
        case dateTime = "datetime_utc"
    }

    func toDomain() throws -> EventModel {
        guard let title = title else {
            let error = EncodingError.Context(codingPath: [EventEntity.CodingKeys.title],
                                              debugDescription: "nil title")
            throw EncodingError.invalidValue(self, error)
        }
        let imageURL = URL(string: performers?.first?.imageURL ?? "")
        let location = venue?.displayLocation
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: dateTime ?? "")
        
        return EventModel(identifier: identifier,
                          title: title,
                          imageURL: imageURL,
                          location: location,
                          date: date)
    }
}

struct PerformerEntity: Decodable {
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image"
    }
}

struct VenueEntity: Decodable {
    let displayLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
    }
}

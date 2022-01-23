//
//  EventsInfoEntity.swift
//  LiveEvents
//
//  Created by Atul Ghorpade on 23/01/22.
//

struct EventsInfoEntity: Decodable {
    let events: [EventEntity]
    let meta: MetaEntity
    
    func toDomain() throws -> EventsInfoModel {
        let eventsModels = try events.map {
            try $0.toDomain()
        }
        
        return EventsInfoModel(events: eventsModels,
                               totalEntitiesAvailable: meta.totalEntitiesAvailable,
                               page: meta.currentPage)
    }
}

struct MetaEntity: Decodable {
    let totalEntitiesAvailable: Int
    let currentPage: Int
    
    enum CodingKeys: String, CodingKey {
        case totalEntitiesAvailable = "total"
        case currentPage = "page"
    }
}

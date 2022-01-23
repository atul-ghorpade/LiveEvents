//
//  EventsInfoModel.swift
//  LiveEvents
//
//  Created by Atul Ghorpade on 23/01/22.
//

import Foundation

struct EventsInfoModel: Equatable {
    let events: [EventModel]
    let totalEntitiesAvailable: Int
    let page: Int
}

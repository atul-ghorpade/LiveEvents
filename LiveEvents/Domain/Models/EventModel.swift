//
//  EventModel.swift
//  LiveEvents
//
//  Created by Atul Ghorpade on 20/01/22.
//

import Foundation

struct EventModel: Equatable {
    let identifier: Int
    let title: String
    let imageURL: URL?
    let location: String?
    let date: Date?
}

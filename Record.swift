//
//  Record.swift
//  TimeTrailSwiftui
//
//  Created by MacBook on 17.08.2024.
//

import Foundation

/// Модель данных для записи
struct Record: Identifiable, Codable {
    let id: UUID
    var text: String
    var startTime: Date
    
    init(id: UUID = UUID(), text: String, startTime: Date = Date()) {
        self.id = id
        self.text = text
        self.startTime = startTime
    }
}

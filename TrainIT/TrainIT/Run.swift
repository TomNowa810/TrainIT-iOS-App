//
//  Run.swift
//  Testproject
//
//  Created by Tom Nowakowski on 06.08.23.
//

import Foundation

class Run: Identifiable {
    
    var id: String
    var number: Int
    var length: Double
    var minutes: Int
    var seconds: Int
    var date: Date
    var minutesTotal: Double
    var averageKmPerKm: Double
    
    init(number: Int, length: Double, minutes: Int, seconds: Int, date: Date) {
        self.id = UUID().uuidString
        self.number = number
        self.length = length
        self.minutes = minutes
        self.seconds = seconds
        self.date = date
        self.minutesTotal = Double(self.minutes) + Double(self.seconds / 60)
        self.averageKmPerKm = round((self.minutesTotal / self.length) * 100) / 100
    }
}

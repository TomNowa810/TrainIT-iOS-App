//
//  Run.swift
//  Testproject
//
//  Created by Tom Nowakowski on 06.08.23.
//

import Foundation


enum ImprovementEnum {
    case improved
    case equal
    case deteriorated
}

class Run: Identifiable {
    
    var id: UUID
    var number: Int
    var length: Double
    var minutes: Int
    var seconds: Int
    var date: Date
    var minutesTotal: Double
    var averageMinPerKm: Double
    var improvement: ImprovementEnum
    
    init(number: Int, length: Double, minutes: Int, seconds: Int, date: Date, minutesTotal: Double, averageKmPerKm: Double, improvement: ImprovementEnum) {
        self.id = UUID()
        self.number = number
        self.length = length
        self.minutes = minutes
        self.seconds = seconds
        self.date = date
        self.minutesTotal = minutesTotal
        self.averageMinPerKm = averageKmPerKm
        self.improvement = improvement
    }
}



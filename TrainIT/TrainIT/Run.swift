//
//  Run.swift
//  Testproject
//
//  Created by Tom Nowakowski on 06.08.23.
//

import Foundation

class Run: Identifiable {
    
    var id: String
    var runNumber: Int
    var runLength: Double
    var runMinutes: Double
    var date: Date
    
    init(runNumber: Int, runLength: Double, runMinutes: Double, date: Date) {
        self.id = UUID().uuidString
        self.runNumber = runNumber
        self.runLength = runLength
        self.runMinutes = runMinutes
        self.date = date
    }
}

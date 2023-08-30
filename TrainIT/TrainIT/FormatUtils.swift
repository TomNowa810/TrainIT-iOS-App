//
//  FormatUtils.swift
//  TrainIT
//
//  Created by Tom Nowakowski on 19.08.23.
//

import Foundation
import SwiftUI

extension DateFormatter {
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.YYYY"
        return formatter
    }()
}

func convertMinutesToStringForView(mins: Double) -> String {
    let secondsTotal = Int(mins * 60);
    let minutes = (secondsTotal % 3600) / 60
    let seconds = secondsTotal % 60
    
    var secondsString = String(seconds)
    
    if secondsString.count == 1 {
        secondsString = "0" + secondsString
    }
    
    return String(minutes) + ":" + secondsString
}

func roundOnTwoDecimalPlaces(value: Double) -> Double {
    return round(value * 100) / 100
}

func roundAndDeviceByRunElements(value: Double, divisionValue: Double) -> Double {
    return roundOnTwoDecimalPlaces(value: (value / divisionValue))
}

struct BackgroundColorGradient : View {
    var body: some View {
        LinearGradient(
            colors: [.white, Color(UIColor(named: "AccentColor") ?? .yellow)],
            startPoint: .leading, endPoint: .bottom)
        .opacity(0.4).padding(-5.0).ignoresSafeArea(.all)
    }
}

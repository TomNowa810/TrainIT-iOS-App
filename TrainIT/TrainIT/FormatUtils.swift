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
        formatter.dateFormat = "dd.MM.YYYY"
        return formatter
    }()
}

func convertMinutesToStringForView(mins: Double) -> String {
    var secondsTotal = Int(mins * 60);
    let hours = (secondsTotal % 216000) / 3600
  
    secondsTotal -= hours * 3600
    
    let minutes = (secondsTotal % 3600) / 60
    let seconds = secondsTotal % 60
    
    
    if hours >  0 {
        return String(hours) + ":" + addZeroIfNeeded(number: String(minutes)) + ":" + addZeroIfNeeded(number: String(seconds))
    }
    
    return String(minutes) + ":" + addZeroIfNeeded(number: String(seconds))
}

private func addZeroIfNeeded(number: String) -> String {
    if number.count == 1 {
        return "0" + number
    }
    return number
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

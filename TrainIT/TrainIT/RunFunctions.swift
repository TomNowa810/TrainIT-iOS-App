//
//  RunFunctions.swift
//  TrainIT
//
//  Created by Tom Nowakowski on 20.08.23.
//

import Foundation
import SwiftUI

func calculateRunValues(runCollection: Array<Run>) -> (
    kmMax: Double,
    kmAvg: Double,
    kmMin: Double,
    minAvg: Double,
    maxAvg: Double,
    avgMinsPerKm: Double
) {
    var kmMax: Double = 0
    var kmAvg: Double = 0
    var kmMin: Double = runCollection.first?.length ?? 10.0
    var minAvg: Double = runCollection.first?.averageMinPerKm ?? 10.00
    var maxAvg: Double = 0
    var avgMinsPerKm: Double = 0
    
    for run in runCollection {
        if kmMin > run.length {
            kmMin = run.length
        }
        
        if minAvg > run.averageMinPerKm {
            minAvg = run.averageMinPerKm
        }
        
        if maxAvg < run.averageMinPerKm {
            maxAvg = run.averageMinPerKm
        }
        
        if kmMax < run.length {
            kmMax = run.length
        }
        
        kmAvg += run.length
        avgMinsPerKm += run.averageMinPerKm
    }
    kmMax = roundOnTwoDecimalPlaces(value: kmMax)
    kmAvg = roundAndDeviceByRunElements(value: kmAvg, divisionValue:  Double(runCollection.count))
    kmMin = roundOnTwoDecimalPlaces(value: kmMin)
    minAvg = roundOnTwoDecimalPlaces(value: minAvg)
    maxAvg = roundOnTwoDecimalPlaces(value: maxAvg)
    avgMinsPerKm = roundAndDeviceByRunElements(value: avgMinsPerKm, divisionValue: Double(runCollection.count))
    
    return (kmMax, kmAvg, kmMin, minAvg, maxAvg, avgMinsPerKm)
}

func arrowValues(run: Run) -> (
    systemName: String,
    color: Color,
    width: Double,
    height: Double
){
    
    switch run.improvement {
        
    case ImprovementEnum.improved :
        return ("arrow.up", .green, 12, 15)
        
    case ImprovementEnum.deteriorated:
        return ("arrow.down", .red, 12, 15)
        
    default:
        return ("equal.circle", .gray, 15, 15)
    }
}

func getImprovementStatus(currentAvg: Double, lastAvg: Double) -> ImprovementEnum {
    if lastAvg == 0 {
        return ImprovementEnum.equal
    }
    
    if currentAvg < lastAvg {
        return ImprovementEnum.improved
    }
    else if currentAvg > lastAvg {
        return ImprovementEnum.deteriorated
    }
    return ImprovementEnum.equal
}

func calculateAvg(minutesTotal: Double, length: Double) -> Double {
    return round((minutesTotal / length) * 100) / 100
}

func calculateMinutesTotal(minutes: Int, seconds: Int) -> Double{
    return Double(minutes) + Double(seconds / 60)
}

//
//  RunFunctions.swift
//  TrainIT
//
//  Created by Tom Nowakowski on 20.08.23.
//

import Foundation
import SwiftUI

var bestKmOfAllRuns_runRefrenceByUuid: UUID? = nil
var bestAvgOfAllRuns_runRefrenceByUuid: UUID? = nil

func calculateRunValues(runCollection: Array<Run>) -> (
    kmMax: Double,
    kmAvg: Double,
    kmMin: Double,
    minAvg: Double,
    maxAvg: Double,
    avgMinsPerKm: Double
) {
    var kmMax: Double = 0
    var bestKm_runUuid: UUID?
    
    var kmAvg: Double = 0
    var kmMin: Double = runCollection.first?.length ?? 9999
    var minAvg: Double = runCollection.first?.averageMinPerKm ?? 9999
    var bestAvg_runUuid: UUID?

    var maxAvg: Double = 0
    var avgMinsPerKm: Double = 0
    
    for run in runCollection {
        if kmMin > run.length {
            kmMin = run.length
        }
        
        if minAvg > run.averageMinPerKm {
            minAvg = run.averageMinPerKm
            bestAvg_runUuid = run.id
        }
        
        if maxAvg < run.averageMinPerKm {
            maxAvg = run.averageMinPerKm
        }
        
        if kmMax < run.length {
            kmMax = run.length
            bestKm_runUuid = run.id
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
    
    bestKmOfAllRuns_runRefrenceByUuid = bestKm_runUuid
    bestAvgOfAllRuns_runRefrenceByUuid = bestAvg_runUuid
    
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
    return roundOnTwoDecimalPlaces(value:  minutesTotal / length)
}

func calculateMinutesTotal(minutes: Int, seconds: Int) -> Double{
    let secondsToMin: Double = Double(seconds) / 60
    return roundOnTwoDecimalPlaces(value: Double(minutes) + secondsToMin)
}

func createSecondStringPart(seconds: Int) -> String {
    if(seconds < 10){
        return "0" + seconds.formatted()
    }
    return seconds.formatted()
}

func calculateValuesAfterSelectedRun(runCollection: Array<Run>, selectedRun: Run) -> (
    number: Int,
    avgLength: Double,
    avgMinutesTotal: Double,
    lastRun: Run
){
    var number: Int = 0
    var avgLength: Double = 0
    var avgMinutesTotal: Double = 0
    let lastRun: Run = runCollection.last!
    
    var isSelectedRunReached: Bool = false
    
    runCollection.forEach { run in
        if isSelectedRunReached {
            number += 1
            avgLength += run.length
            avgMinutesTotal += run.minutesTotal
        }
        
        if run.id == selectedRun.id {
            isSelectedRunReached = true
        }
    }
    
    avgLength = avgLength/Double(number)
    avgMinutesTotal = avgMinutesTotal/Double(number)
    
    return (number,avgLength,avgMinutesTotal,lastRun)
}

enum TrophyVisualizationStatus {
    case trophyLessRow
    case none
    case trophy
}

func trophyCheckByUuid(id: UUID, isKmChecked: Bool) -> TrophyVisualizationStatus {
    if isKmChecked {
        if id == bestKmOfAllRuns_runRefrenceByUuid {
            return TrophyVisualizationStatus.trophy
        } else {
            return TrophyVisualizationStatus.none
        }
    } else {
        if id == bestAvgOfAllRuns_runRefrenceByUuid {
            return TrophyVisualizationStatus.trophy
        } else {
            return TrophyVisualizationStatus.none
        }
    }
}

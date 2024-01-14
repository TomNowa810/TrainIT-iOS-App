
import Foundation
import SwiftUI

struct RunInsight: View {
    var run: Run
    @Binding var runCollection: Array<Run>
    @Binding var showDetails : Bool
    
    var body: some View {
        VStack(spacing: 30) {
            
            HStack {
                VStack {
                    HStack {
                        Text("Lauf Nummer: ")
                        Text(run.number.formatted())
                            .foregroundStyle(defaultGradient)
                        
                        Spacer()
                        
                    }.padding(.top, 15)
                    HStack {
                        Text(DateFormatter.displayDate.string(from: run.date))
                            .font(.system(size:15))
                            .foregroundColor(.gray)
                            .italic()
                        
                        Spacer()
                    }.padding(.leading, 30.0)
                    
                }.padding(.leading, 10.0)
                    .font(.system(size: 25))
                    .fontWeight(.light)
                
                Spacer()
                
                Button(action: {
                    showDetails = false
                }, label: {
                    Circle()
                        .fill(.white)
                        .shadow(color: Color.indigo.opacity(0.5), radius: 20)
                        .frame(width: 30, height: 30)
                        .overlay(
                            
                            Image(systemName: "multiply")
                                .frame(width: 100, height: 100)
                                .foregroundColor(.indigo))
                })
            }.padding(.trailing, 30.0)
            
            
            Divider().frame(width: 250)
            
            RunInsightDetailRow(
                rowDescription: "Strecke",
                value: run.length.formatted(),
                unit: "km",
                trophyStatus: trophyCheckOnValueByUuid(id: run.id, isKmChecked: true))
            
            RunInsightDetailRow(
                rowDescription: "Zeit",
                value: convertMinutesToStringForView(mins: run.minutesTotal),
                unit: "",
                trophyStatus: TrophyVisualizationStatus.trophyLessRow)
            
            RunInsightDetailRow(
                rowDescription: "Durchschnitt",
                value: convertMinutesToStringForView(mins: run.averageMinPerKm),
                unit: "m/km",
                trophyStatus: trophyCheckOnValueByUuid(id: run.id, isKmChecked: false))
            
            Divider().frame(width: 250)
            
            let (numberOfRuns, avgLength, avgMinsTotal) = calculateValuesAfterSelectedRun(runCollection: runCollection, selectedRun: run)
            
            if runCollection.count > 2 && numberOfRuns > 1{
                
                VStack(spacing: 10) {
                    Text("Anzahl folgender Läufe")
                        .foregroundColor(.gray)
                        .fontWeight(.light)
                    
                    Text(numberOfRuns.formatted())
                        .foregroundStyle(calculationGradient)
                }
                
                VStack(spacing: 20){
                    HStack(spacing: 80) {
                        ComparisonNavigationLinkStruct(
                            calcValue: avgLength.formatted(),
                            value: run.length.formatted(),
                            unitDescription: "km  "
                        )
                        
                        ComparisonNavigationLinkStruct(
                            calcValue: convertMinutesToStringForView(mins: avgMinsTotal),
                            value: convertMinutesToStringForView(mins: run.minutesTotal),
                            unitDescription: "zeit "
                        )
                        
                    }
                    
                    HStack {
                        let avg: Double = avgMinsTotal / avgLength
                        
                        ComparisonNavigationLinkStruct(
                            calcValue: convertMinutesToStringForView(mins: roundOnTwoDecimalPlaces(value: avg)),
                            value: convertMinutesToStringForView(mins: run.averageMinPerKm),
                            unitDescription: "m/km"
                        )
                    }
                }
                
            } else {
                NoStatisticOnInsightView(numberOfRuns: numberOfRuns)
            }
            
            Spacer()
        }
        .frame(width: 320, height: 525)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
    }
}

struct RunInsightDetailRow: View {
    var rowDescription: String
    var value: String
    var unit: String
    var trophyStatus: TrophyVisualizationStatus
    
    
    @ViewBuilder
    var buildTrophyVisualisation : some View {
        if trophyStatus != TrophyVisualizationStatus.trophyLessRow {
            if trophyStatus == TrophyVisualizationStatus.none {
                Image(systemName: "viewfinder")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
                    .padding(.leading, 30.0)
            } else if trophyStatus == TrophyVisualizationStatus.trophy {
                Image(systemName: "trophy")
                    .resizable()
                    .frame(width: 20, height: 25)
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [Color("TrophyPrimary"), Color("TrophySecondary")]),
                        startPoint: .top,
                        endPoint: .bottom
                    )).padding(.leading, 30.0)
                    .shadow(color: .yellow, radius: 15)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Spacer()
                
                Text(rowDescription + " : ")
                    .font(.system(size: 16))
            }
            
            HStack(spacing: 5) {
                
                Text(value)
                    .foregroundStyle(defaultGradient)
                    .font(.system(size: 20))
                
                Text(unit)
                    .font(.system(size: 6))
                    .padding(.top, 8.0)
                    .foregroundColor(.gray)
                
                Spacer()
                
                buildTrophyVisualisation
                
            }
            .padding(.trailing, 20)
        }
        .fontWeight(.light)
    }
}

struct NoStatisticOnInsightView: View {
    var numberOfRuns: Int
    
    
    @ViewBuilder
    var buildDescription: some View {
        if numberOfRuns == 1 {
            VStack {
                Text("Vorletzte Läufe haben keine Statistiken")
                
                HStack(spacing: 0) {
                    Text("zu den ")
                    
                    Text("folgenden ")
                        .fontWeight(.regular)
                    
                    Text("Läufen")
                }
            }.fontWeight(.thin)
            
        } else if numberOfRuns == 0 {
            VStack {
                Text("Letzte Läufe haben keine Statistiken")
                
                HStack(spacing: 0) {
                    Text("zu den ")
                    
                    Text("folgenden ")
                        .fontWeight(.regular)
                    
                    Text("Läufen")
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            Image(systemName: "figure.mixed.cardio")
                .resizable()
                .foregroundStyle(calculationGradient)
                .frame(width: 80, height: 100)
                .opacity(0.5)
            
            buildDescription
            
        }
        .frame(width: 320)
        .multilineTextAlignment(.center)
        .fontWeight(.light)
        .font(.system(size: 16))
    }
}

struct ComparisonNavigationLinkStruct: View {
    var calcValue: String
    var value: String
    var unitDescription: String
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "arrow.up.arrow.down")
                    .resizable()
                    .frame(width: 8, height: 8)
            }
            VStack(spacing: 0) {
                Text(calcValue)
                    .foregroundStyle(calculationGradient)
                
                Divider().frame(width: 25)
                
                Text(value)
                    .foregroundStyle(defaultGradient)
                    .opacity(0.4)
            }
            VStack {
                Rectangle()
                    .fill(.white)
                    .frame(width: 30, height: 20)
                    .overlay(
                        Text("Ø")
                        , alignment: .leading)
                    .overlay(
                        Text(unitDescription)
                            .font(.system(size: 6))
                            .foregroundColor(.gray)
                        , alignment: .bottomTrailing)
            }
        }.padding(.leading, 20)
    }
}

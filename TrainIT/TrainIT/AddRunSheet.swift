import Foundation
import SwiftUI

struct AddRunSheet: View {
    
    @State private var kilometerAmount: String = ""
    @State private var minutesAmount: String = ""
    @State private var secondsAmount: String = ""
    @State private var date = Date()
    
    @Binding var showRunSheet: Bool
    @Binding var runCollection: Array<Run>
    
    @State private var kmTextFieldColor: Color = .gray.opacity(0.2)
    @State private var minutesTextFieldColor: Color = .gray.opacity(0.2)
    @State private var secondsTextFieldColor: Color = .gray.opacity(0.2)
    
    @State private var isKmFieldEmpty: Bool = false
    @State private var isMinsFieldEmpty: Bool = false
    @State private var isSecsFieldEmpty: Bool = false
    
    @State private var isSecsInCorrectRange: Bool = true
    
    
    var body: some View {
        VStack{
            HStack {
                VStack(alignment: .leading) {
                    Text("Lauf")
                    Text("hinzufügen")
                }.foregroundStyle(.black)
                    .font(.system(size: 35))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                VStack {
                    Button(role: .cancel,
                           action: {
                        showRunSheet.toggle()},
                           label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "multiply")
                                    .resizable()
                                    .foregroundColor(.indigo)
                                    .frame(width: 15, height: 15)
                            )
                            .padding()
                            .shadow(color: Color.indigo.opacity(0.6), radius: 21)
                            .opacity(0.8)
                    }
                    )
                    Spacer()
                        .frame(height: 30.0)
                }
                
            }.padding().frame(height: 120.0)
            
            VStack {
                HStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 23)
                        .overlay(
                            Image(systemName: "road.lanes")
                                .resizable()
                                .frame(width: 25, height: 20)
                                .foregroundColor(.indigo)
                        )
                    
                    TextField("Anzahl der Kilometer", text: $kilometerAmount)
                        .keyboardType(.decimalPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(kmTextFieldColor, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                }
                
                if isKmFieldEmpty {
                    Text("Trage noch die Kilometer ein!").font(.system(size: 13)).italic()
                }
                
                HStack {
                    AddRunClockSymbol(unitDescription: "Min.")
                    
                    TextField("Anzahl der Minuten", text: $minutesAmount)
                        .keyboardType(.numberPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(minutesTextFieldColor, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                }
                
                if isMinsFieldEmpty {
                    Text("Trage noch die Minuten ein!").font(.system(size: 13)).italic()
                }
                
                HStack {
                    AddRunClockSymbol(unitDescription: "Sek.")
                    
                    TextField("Anzahl der Sekunden", text: $secondsAmount)
                        .keyboardType(.numberPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(secondsTextFieldColor, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                }
                
                if isSecsFieldEmpty {
                    Text("Trage noch die Sekunden ein!").font(.system(size: 13)).italic()
                } else if !isSecsInCorrectRange {
                    Text("Es werden nur Werte von 0 - 59 akzeptiert!").font(.system(size: 13)).italic()
                }
                
                DatePicker(
                    "Tag des Laufes",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                
                Spacer().frame(height: 50)
                
                Button(action: {
                    
                    if kilometerAmount.isEmpty {
                        kmTextFieldColor = .red
                        isKmFieldEmpty = true
                    } else {
                        kmTextFieldColor = .gray.opacity(0.2)
                        isKmFieldEmpty = false
                    }
                    
                    if minutesAmount.isEmpty {
                        minutesTextFieldColor = .red
                        isMinsFieldEmpty = true
                    } else {
                        minutesTextFieldColor = .gray.opacity(0.2)
                        isMinsFieldEmpty = false
                    }
                    
                    if secondsAmount.isEmpty {
                        secondsTextFieldColor = .red
                        isSecsFieldEmpty = true
                        
                    } else if Int(secondsAmount)! < 60{
                        secondsTextFieldColor = .gray.opacity(0.2)
                        isSecsInCorrectRange = true
                        isSecsFieldEmpty = false
                        
                    } else {
                        secondsTextFieldColor = .red
                        isSecsFieldEmpty = false
                        isSecsInCorrectRange = false
                    }
                    
                    if !isKmFieldEmpty && !isMinsFieldEmpty && !isSecsFieldEmpty && isSecsInCorrectRange{
                        
                        addRun(length: Double(kilometerAmount.replacing(",", with: ".")) ?? 0,
                               minutes: Int(minutesAmount) ?? 0,
                               seconds: Int(secondsAmount) ?? 0,
                               date: date)
                        showRunSheet.toggle()
                    }
                }, label: {
                    Rectangle()
                        .fill(.thinMaterial)
                        .frame(width: 120, height: 45)
                        .cornerRadius(20)
                        .overlay(Text("Hinzufügen")
                            .foregroundColor(.indigo))
                })
                
            }.padding().frame(maxWidth: .infinity,
                              maxHeight: .infinity,
                              alignment: .center)
        }.presentationDetents([.large, .medium, .fraction(0.5)])
    }
    func addRun(length: Double, minutes: Int, seconds: Int, date: Date){
        let lastAvg: Double = runCollection.last?.averageMinPerKm ?? 0
        let minutesTotal: Double = calculateMinutesTotal(minutes: minutes, seconds: seconds)
        let currentAvg: Double = calculateAvg(minutesTotal: minutesTotal, length: length)
        
        let improvementStatus: ImprovementEnum = getImprovementStatus(currentAvg: currentAvg, lastAvg: lastAvg)
        
        runCollection.append(
            Run(
                number: runCollection.count + 1,
                length: length,
                minutes: minutes,
                seconds: seconds,
                date: date,
                minutesTotal: minutesTotal,
                averageKmPerKm: currentAvg,
                improvement: improvementStatus
            )
        )
    }
}

struct AddRunClockSymbol: View {
    
    let unitDescription: String
    
    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: 40, height: 23)
            .overlay(
                Image(systemName: "clock")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.indigo)
            )
            .overlay(
                Rectangle()
                    .fill(.gray)
                    .frame(width: 20, height: 10)
                    .cornerRadius(20)
                    .overlay(
                        Text(unitDescription)
                            .foregroundColor(.white)
                            .font(.system(size: 7))
                    )
                , alignment: .bottomTrailing)
    }
}

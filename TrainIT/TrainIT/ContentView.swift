import SwiftUI

struct ContentView: View {
    
    @State var showRunSheet: Bool = false
    
    @State var runCollection = [
        Run(
            number: 1 ,
            length: 5.89,
            minutes: 46,
            seconds: 23,
            date: Date.now,
            minutesTotal: 46.35,
            averageKmPerKm: 7.86,
            improvement: ImprovementEnum.equal
        )
    ]
    
    var body: some View {
        TabView {
            
            // RUNS
            NavigationStack {
                
                List {
                    ForEach(runCollection) {
                        run in
                        NavigationLink(destination: RunInsights(run: run)){
                            RunListElement(run: run)
                        }
                    }
                    Section(header: Text("Auswertung")) {
                        RunPredictionElement(runCollection: $runCollection)
                    }
                }
                .navigationTitle("Alle Läufe")
                .navigationBarItems(trailing:
                                        Button(action: {
                    showRunSheet.toggle()
                }, label: {
                    Image(systemName: "square.and.pencil")
                }))
            }.sheet(isPresented: $showRunSheet, content: {
                AddRunView(showRunSheet: $showRunSheet, runCollection: $runCollection)
            })
            .tabItem{
                Image(systemName: "figure.run.square.stack")
                Text("Alle Läufe (" + runCollection.count.formatted() + ")")
            }
            // HOME - Übersicht
            Text("Überblick")
                .tabItem {
                    Image(systemName: "medal")
                        .foregroundColor(.blue)
                    Text("Überblick")
                    
                }
        }
    }
}

struct AddRunView: View {
    
    @State private var kilometerAmount: String = ""
    @State private var minutesAmount: String = ""
    @State private var date = Date()
    
    @Binding var showRunSheet: Bool
    @Binding var runCollection: Array<Run>
    
    var body: some View {
        ZStack{
            HStack {
                Text("Lauf hinzufügen")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                Button("Abbrechen",
                       role: .cancel,
                       action: {
                    showRunSheet.toggle()}).frame(maxWidth: .infinity, maxHeight:.infinity , alignment:.topTrailing)
            }.padding()
            
            VStack(alignment: .center) {
                TextField("Anzahl der Kilometer", text: $kilometerAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Anzahl der Minuten", text: $minutesAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                
                Button("Hinzufügen", action: {
                    addRuns(length: Double(kilometerAmount.replacing(",", with: ".")) ?? 0,
                            minutes: Int(minutesAmount) ?? 0,
                            seconds: 20,
                            date: date)
                    showRunSheet.toggle()
                }).buttonStyle(.bordered)
                
            }.padding()
            
        }
    }
    func addRuns(length: Double, minutes: Int, seconds: Int, date: Date){
        let lastAvg = runCollection.last?.averageKmPerKm ?? 0
        let minutesTotal = calculateMinutesTotal(minutes: minutes, seconds: seconds)
        let currentAvg = calculateAvg(minutesTotal: minutesTotal, length: length)
        
        var improvementParam: ImprovementEnum {
            if(currentAvg < lastAvg) {
                return ImprovementEnum.improved
            }
            else if(currentAvg > lastAvg) {
                return ImprovementEnum.deteriorated
            }
            return ImprovementEnum.equal
        }
        
        runCollection.append(Run(number: runCollection.count + 1, length: length, minutes: minutes, seconds: seconds, date: date, minutesTotal: minutesTotal, averageKmPerKm: currentAvg, improvement: improvementParam))
    }
    
    func calculateAvg(minutesTotal: Double, length: Double) -> Double {
        return round((minutesTotal / length) * 100) / 100
    }
    
    func calculateMinutesTotal(minutes: Int, seconds: Int) -> Double{
        return Double(minutes) + Double(seconds / 60)
    }
}


struct RunInsights: View {
    var run: Run
    
    var body: some View {
        VStack {
            Image(systemName: "figure.mixed.cardio")
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
            Text("Durchschnittlichen Minuten pro KM:")
            Text(run.averageKmPerKm.formatted() + " Min")
        }
    }
}

extension DateFormatter {
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM YYYY"
        return formatter
    }()
}

struct RunListElement: View {
    var run: Run
    
    var body: some View {
        HStack {
            Image(systemName: "figure.run")
                .resizable()
                .frame(width: 25, height: 32)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text("Lauf " + run.number.formatted())
                    .font(.system(size: 15))
                    .italic()
                
                Text(DateFormatter.displayDate.string(from: run.date))
                    .foregroundColor(.secondary)
                    .font(.system(size: 10))
                
            }
            
            Spacer().frame(width: 28.0)
            
            VStack {
                Text(run.minutes.formatted() + ":" + run.seconds.formatted())
                Text(run.length.formatted() + " km")
            }.font(.system(size: 12))
            
            Spacer()
            
            let(systemName, color, width, heigh) = arrowValues(run: run)
            
            Image(systemName: systemName)
                .resizable()
                .frame(width: width, height: heigh)
                .foregroundColor(color)
            
            Spacer()
                .frame(width: 4.0)
            
            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text(run.averageKmPerKm.formatted())
                    .font(.system(size: 18))
            }
            
            VStack {
                Text("Ø").font(.system(size: 12))
                Text("mins").font(.system(size: 10)).foregroundColor(.gray)
            }
        }
    }
    func arrowValues(run: Run) -> (
        systemName: String,
        color: Color,
        width: Double,
        height: Double
    ){
        
        switch run.improvement {
            
        case ImprovementEnum.improved :
            return ("arrowshape.up", .green, 12, 15)
            
        case ImprovementEnum.deteriorated:
            return ("arrowshape.down", .red, 12, 15)
            
        default:
            return ("equal.circle", .gray, 15, 15)
        }
    }
}

struct RunPredictionElement: View {
    @Binding var runCollection: Array<Run>
    
    var kmAvg: Double {
        var sum: Double = 0
        
        for run in runCollection {
            sum += run.length
        }
        return sum
    }
    
    var minAvg: Double {
        var sum: Double = 0
        
        for run in runCollection {
            sum += run.minutesTotal
        }
        return sum
    }
    
    var avgMinsPerKm: Double {
        var sum: Double = 0
        
        for run in runCollection {
            sum += run.averageKmPerKm
        }
        return sum
    }
    
    
    var body: some View {
        
        HStack {
            Image(systemName: "bonjour")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.green)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Ø Km")
                }

                
                HStack {
                    Text("Ø Min")
                }
            }.font(.system(size: 13))
        }
    }
}

// Vorschau
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

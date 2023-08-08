import SwiftUI

struct ContentView: View {
    
    @State var showRunSheet: Bool = false
    
    @State var runCollection = [
        Run(runNumber: 1 , runLength: 5.89, runMinutes: 46.33, date: Date.now),
        Run(runNumber: 2 , runLength: 5.89, runMinutes: 46.33, date: Date.now),
        Run(runNumber: 3 , runLength: 5.89, runMinutes: 46.33, date: Date.now),
        Run(runNumber: 4 , runLength: 5.89, runMinutes: 46.33, date: Date.now)
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
                    Section(header: Text("Geschätzter Nächster Lauf")) {
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
                Text("Alle Läufe")
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
                
                Button("Abbrechen", role: .cancel, action: {showRunSheet.toggle()}).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
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
                    addRuns(runLength: Double(kilometerAmount.replacing(",", with: ".")) ?? 0, runMinutes: Double(minutesAmount.replacing(",", with: ".")) ?? 0, date: date)
                    showRunSheet.toggle()
                }).buttonStyle(.bordered)
                
            }.padding()
            
        }
    }
    func addRuns(runLength: Double, runMinutes: Double, date: Date){
        runCollection.append(Run(runNumber: runCollection.count + 1, runLength: runLength, runMinutes: runMinutes, date: date))
    }
}

struct RunInsights: View {
    var run: Run
    
    var body: some View {
        VStack {
            let calculatedMinutesPerKm = round((run.runMinutes / run.runLength) * 100) / 100
            Image(systemName: "figure.mixed.cardio")
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
            Text("Durchschnittlichen Minuten pro KM:")
            Text(calculatedMinutesPerKm.formatted() + " Min")
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
                HStack {
                    Text("Lauf " + run.runNumber.formatted())
                        .font(Font.headline)
                    
                    Spacer()
                    
                    Text(DateFormatter.displayDate.string(from: run.date))
                        .foregroundColor(.secondary)
                        .font(.system(size: 13))
                }
                
                HStack {
                    Text(run.runLength.formatted() + " km")
                    Text(run.runMinutes.formatted() + " min")
                }.font(Font.subheadline)
            }
        }
    }
}

struct RunPredictionElement: View {
    @Binding var runCollection: Array<Run>
    
    var body: some View {
        HStack {
            Image(systemName: "figure.run")
                .resizable()
                .frame(width: 25, height: 32)
                .foregroundColor(.green)
            
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Lauf " + run.runNumber.formatted())
                        .font(Font.headline)
                    
                    Spacer()
                    
                    Text(DateFormatter.displayDate.string(from: run.date))
                        .foregroundColor(.secondary)
                        .font(.system(size: 13))
                }
                
                HStack {
                    Text(run.runLength.formatted() + " km")
                    Text(run.runMinutes.formatted() + " min")
                }.font(Font.subheadline)
            }
        }
    }
}

// Vorschau
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

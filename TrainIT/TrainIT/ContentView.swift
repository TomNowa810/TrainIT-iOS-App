import SwiftUI

struct ContentView: View {
        
    @State var showRunSheet: Bool = false
    @State var runList = [
        Run(runNumber: 1 , runLength: 5.89, runMinutes: 46.33, date: Date.now)
    ]
    
    @State private var kilometerAmount: String = ""
    @State private var minutesAmount: String = ""
    
    @State private var date = Date()

    
    var body: some View {
        TabView {
            
            // RUNS
            NavigationView {
                
                NavigationLink(destination: Text("Überblick")){
                    List(runList) {
                        run in
                        RunRow(run: run)
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
            })
            .tabItem{
                Image(systemName: "figure.run.square.stack")
                Text("Alle Läufe")
            }
            // HOME
            Text("Überblick")
                .tabItem {
                    Image(systemName: "medal")
                        .foregroundColor(.blue)
                    Text("Überblick")
                    
                }
        }
    }
    func addRuns(runLength: Double, runMinutes: Double, date: Date){
        runList.append(Run(runNumber: runList.count + 1, runLength: runLength, runMinutes: runMinutes, date: date))
    }
}

extension DateFormatter {
    static let displayDate: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "dd MMMM YYYY"
         return formatter
    }()
}

struct RunRow: View {
    var run: Run
    
    var body: some View {
        HStack {
            Image(systemName: "figure.run")
                .resizable()
                .frame(width: 25, height: 32)
                .foregroundColor(.blue)
               
            
            VStack(alignment: .leading) {
                Text("Lauf " + run.runNumber.formatted())
                    .font(Font.headline)
                
                HStack {
                    Text(run.runLength.formatted() + " km")
                    Text(run.runMinutes.formatted() + " min")
                }.font(Font.subheadline)
            }
            
            Spacer()
            
            Text(DateFormatter.displayDate.string(from: run.date))
                .foregroundColor(.secondary)
        }
    }
}

// Vorschau
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

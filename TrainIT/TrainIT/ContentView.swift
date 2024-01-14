import SwiftUI
import Shiny

struct ContentView: View {
    
    @State var showRunSheet: Bool = false
    
    @State var runCollection: Array<Run> = [
        Run(
            number: 1,
            length: 5.08,
            minutes: 32,
            seconds: 37,
            date: Date.now,
            minutesTotal: 32.62,
            averageKmPerKm: 6.61,
            improvement: ImprovementEnum.equal
        ),
        Run(
            number: 2,
            length: 4.91,
            minutes: 28,
            seconds: 42,
            date: Date.now,
            minutesTotal: 28.73,
            averageKmPerKm: 5.83,
            improvement: ImprovementEnum.improved
        ),
        Run(
            number: 3,
            length: 5.53,
            minutes: 36,
            seconds: 30,
            date: Date.now,
            minutesTotal: 36.5,
            averageKmPerKm: 6.60,
            improvement: ImprovementEnum.deteriorated
        )]
    
    @State var showDetails: Bool = false
    @State var selectedRun: Run?
    
    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    
                    AllRunsView(
                        showRunSheet: $showRunSheet,
                        runCollection: $runCollection,
                        show: $showDetails,
                        selectedRun: $selectedRun
                    )
                    
                }
                .blur(radius: showDetails ? 10 : 0)
                .sheet(isPresented: $showRunSheet, content: {
                    AddRunSheet(showRunSheet: $showRunSheet, runCollection: $runCollection)
                })
                .tabItem{
                    Image(systemName: "figure.run.square.stack")
                    Text("Alle Läufe (" + runCollection.count.formatted() + ")")
                }
                
                // HOME - Übersicht
                Text("Überblick").shiny()
                    .tabItem {
                        Image(systemName: "medal")
                        Text("Überblick")
                    }
            }.accentColor(.indigo.opacity(0.8))
            
            
            if showDetails {
                RunInsight(run: selectedRun!, runCollection: $runCollection, showDetails: $showDetails)
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

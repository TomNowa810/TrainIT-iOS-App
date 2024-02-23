import Foundation
import SwiftUI

struct AllRunsView: View {
    @Binding var showRunSheet: Bool
    @Binding var runCollection: Array<Run>
    
    @Binding var show: Bool
    @Binding var selectedRun: Run?
    
    var body: some View {
        ZStack {
            List {
                
                if !runCollection.isEmpty {
                    Section {
                        ForEach(runCollection) {
                            run in
                            
                            RunListElement(runCollection: $runCollection, run: run)
                                .onTapGesture {
                                    selectedRun = run
                                    show = true
                                }
                            
                        }
                        //.onDelete(perform: deleteRun)
                    }
                    if runCollection.count == 1 {
                        OnlyOneRunMask()
                    }
                } else {
                    EmptyRunsListMask()
                }
                
                if runCollection.count > 1 {
                    Section(header: Text("Auswertung")) {
                        CalculationView(runCollection: $runCollection)
                    }
                }
            }
            .disabled(show)
            .navigationTitle("Alle Läufe")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showRunSheet.toggle()},
                           label: {
                               Circle()
                                   .fill(.white)
                                   .frame(width: 30, height: 30)
                                   .overlay(
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.indigo)
                                   )
                                   .padding()
                                   .shadow(color: Color.indigo.opacity(0.2), radius: 7)
                                   .opacity(0.85)
                           })
            )
        }
    }
    func deleteRun(at offset: IndexSet) {
        runCollection.remove(atOffsets: offset)
    }
}

struct RunListElement: View {
    @ScaledMetric var space = 8
    @Binding var runCollection : Array<Run>
    
    var run: Run
    
    var widthSpacer: Double {
        if(String(run.length).count == 3){
            return 50
        }
        return 46
    }
    
    var body: some View {
        HStack(spacing: space) {
            
            HStack {
                FigureOnListElement(runCollection: $runCollection, run: run)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Lauf " + run.number.formatted())
                        .font(.system(size: 21))
                        .italic()
                    
                    Text(DateFormatter.displayDate.string(from: run.date))
                        .foregroundColor(.secondary)
                        .font(.system(size: 10))
                }
                
                Spacer()
                    .frame(width: widthSpacer)
                
                VStack(alignment: .center) {
                    Text(convertMinutesToStringForView(mins: run.minutesTotal))
                    Text(run.length.formatted() + " km")
                }.font(.system(size: 16))
            }
            
            let(systemName, color, width, heigh) = arrowValues(run: run)
            let formattedAvg = convertMinutesToStringForView(mins: run.averageMinPerKm)
            
            Spacer()
            
            HStack {
                Image(systemName: systemName)
                    .resizable()
                    .frame(width: width, height: heigh)
                    .foregroundColor(color)
                
                Text(formattedAvg)
                    .font(.system(size: 23))
                
                
                VStack {
                    Text("Ø").font(.system(size: 12))
                    Text("m\\km").font(.system(size: 10)).foregroundColor(.gray)
                }
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 5)
    }
}

struct FigureOnListElement: View {
    @Binding var runCollection : Array<Run>
    var run: Run
    
    var body: some View {
        if trophyCheckByUuid(id: run.id) {
            DefaultFigure()
                .overlay(
                    Image(systemName: "trophy.fill")
                        .resizable()
                        .frame(width: 10, height: 12)
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [.yellow, Color("TrophyPrimary")]),
                            startPoint: .top,
                            endPoint: .bottom
                        )), alignment: .bottomTrailing)
        } else {
            DefaultFigure()
        }
    }
}

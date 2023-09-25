import SwiftUI
import Shiny

struct ContentView: View {
    
    @State var showRunSheet: Bool = false
    
    @State var runCollection: Array<Run> = []
    
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    
                    if !runCollection.isEmpty {
                        Section {
                            ForEach(runCollection) {
                                run in
                                NavigationLink(destination: RunInsight(run: run, runCollection: $runCollection)){
                                    RunListElement(run: run)
                                }
                            }.onDelete(perform: deleteRun)
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
            }.sheet(isPresented: $showRunSheet, content: {
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
    }
    func deleteRun(at offset: IndexSet) {
        runCollection.remove(atOffsets: offset)
    }
}

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

struct RunInsight: View {
    var run: Run
    @Binding var runCollection: Array<Run>
    
    var body: some View {
        VStack(spacing: 30) {
            
            HStack {
                VStack {
                    HStack {
                        Text("Lauf Nummer: ")
                        Text(run.number.formatted())
                            .foregroundStyle(defaultGradient)
                        
                        Spacer()
                        
                    }
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
                
                Circle()
                    .fill(.white)
                    .shadow(color: Color.indigo.opacity(0.5), radius: 20)
                    .frame(width: 30, height: 30)
                    .overlay(Image(systemName: "trash")                             // TODO -> convert 2 Btn
                        .frame(width: 100, height: 100)
                        .foregroundColor(.indigo))
                
                
                
            }.padding(.trailing, 30.0)
            
            
            Divider().frame(width: 250)
            
            NavigationLinkRow(
                rowDescription: "Strecke",
                value: run.length.formatted(),
                unit: "km",
                trophyStatus: trophyCheckOnValueByUuid(id: run.id, isKmChecked: true))
            
            NavigationLinkRow(
                rowDescription: "Zeit",
                value: convertMinutesToStringForView(mins: run.minutesTotal),
                unit: "",
                trophyStatus: TrophyVisualizationStatus.trophyLessRow)
            
            NavigationLinkRow(
                rowDescription: "Durchschnitt",
                value: convertMinutesToStringForView(mins: run.averageMinPerKm),
                unit: "m/km",
                trophyStatus: trophyCheckOnValueByUuid(id: run.id, isKmChecked: false))
            
            Divider().frame(width: 250)
            
            Image(systemName: "figure.mixed.cardio")
                .foregroundStyle(defaultGradient)
                .frame(width: 50, height: 50)
            
            
            Text("Hier würdest du weitere Statistiken zu deinen folgenen Läufen sehen")
                .multilineTextAlignment(.center)
                .italic()
                .font(.system(size: 15))
                .fontWeight(.light)
            
            
            Spacer()
        }
    }
}

struct NavigationLinkRow: View {
    var rowDescription: String
    var value: String
    var unit: String
    var trophyStatus: TrophyVisualizationStatus
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
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
                
                Spacer()
                
                Text(rowDescription + " : ")
            }
            
            HStack {
                
                Text(value)
                    .foregroundStyle(defaultGradient)
                
                Text(unit)
                    .font(.system(size: 10))
                    .padding(.top, 6.0)
                
                Spacer()
            }
            
        }.font(.system(size: 20))
            .fontWeight(.light)
    }
}

struct RunListElement: View {
    @ScaledMetric var space = 8
    
    var run: Run
    
    var widthSpacer: Double {
        if(String(run.length).count == 3){
            return 50
        }
        return 46
    }
    
    var body: some View {
        HStack(spacing: space) {
            Spacer()
                .frame(width: 14.0)
            
            HStack {
                FigureOnListElement(isWithTrophy: trophyCheckByUuid(id: run.id))
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
                    Text(run.minutes.formatted() + ":" + createSecondStringPart(seconds: run.seconds))
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
        }.padding().frame(width: 400.0, height: 60.0)
    }
}

struct CalculationView: View {
    @Binding var runCollection: Array<Run>
    
    var body: some View {
        let (kmMax, kmAvg, kmMin, minAvg, maxAvg, avgMinsPerKm) = calculateRunValues(runCollection: runCollection)
        
        ScrollView(.horizontal, showsIndicators: true) {
            ScrollViewReader {
                value in
                
                HStack(spacing: 100) {
                    
                    CalculationPageStructure(
                        headline: "Distanz",
                        isFirstView: true,
                        firstSymbol:
                            CalculationSymbol(
                                imageName: "road.lanes",
                                imageWidth: 22,
                                imageHeight: 20,
                                isArrow: false,
                                color: .gray,
                                content: "Ø")
                        ,
                        firstValue: kmAvg.formatted()
                        , secondSymbol: CalculationSymbol(
                            imageName: "road.lanes",
                            imageWidth: 22,
                            imageHeight: 20,
                            isArrow: true,
                            color: .green,
                            content: "arrow.up"
                        ),
                        secondValue: kmMax.formatted(),
                        thirdSymbol: CalculationSymbol(
                            imageName: "road.lanes",
                            imageWidth: 22,
                            imageHeight: 20,
                            isArrow: true,
                            color: .red,
                            content: "arrow.down"
                        ),
                        thirdValue: kmMin.formatted(),
                        scrollViewProxy: value
                    ).id(1)
                    
                    CalculationPageStructure(
                        headline: "Zeit",
                        isFirstView: false,
                        firstSymbol:
                            CalculationSymbol(
                                imageName: "clock.arrow.2.circlepath",
                                imageWidth: 24,
                                imageHeight: 20,
                                isArrow: false,
                                color: .gray,
                                content: "Ø")
                        ,
                        firstValue: convertMinutesToStringForView(mins: avgMinsPerKm)
                        , secondSymbol: CalculationSymbol(
                            imageName: "clock.arrow.2.circlepath",
                            imageWidth: 24,
                            imageHeight: 20,
                            isArrow: true,
                            color: .green,
                            content: "arrow.up"
                        ),
                        secondValue: convertMinutesToStringForView(mins: minAvg),
                        thirdSymbol: CalculationSymbol(
                            imageName: "clock.arrow.2.circlepath",
                            imageWidth: 24,
                            imageHeight: 20,
                            isArrow: true,
                            color: .red,
                            content: "arrow.down"
                        ),
                        thirdValue: convertMinutesToStringForView(mins: maxAvg),
                        scrollViewProxy: value
                    ).id(2)
                }
            }
        }
    }
}

struct CalculationPageStructure: View {
    
    let headline: String
    let isFirstView: Bool
    
    let firstSymbol: CalculationSymbol
    let firstValue: String
    
    let secondSymbol: CalculationSymbol
    let secondValue: String
    
    let thirdSymbol: CalculationSymbol
    let thirdValue: String
    
    let scrollViewProxy: ScrollViewProxy
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    
                    if(!isFirstView) {
                        Button(action: {
                            scrollViewProxy.scrollTo(1)
                        }, label: {
                            Image(systemName: "return")
                                .resizable()
                                .frame(width: 13, height: 10)
                                .foregroundColor(.gray)
                        })
                    }
                    
                    Spacer()
                    
                    Text(headline)
                        .font(.subheadline)
                        .foregroundColor(.indigo)
                        .opacity(0.85)
                    
                    Text("- Werte")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    
                    if(isFirstView) {
                        Button(action: {
                            scrollViewProxy.scrollTo(2)
                        }, label: {
                            Image(systemName: "arrow.turn.up.right")
                                .resizable()
                                .frame(width: 13, height: 10)
                                .foregroundColor(.gray)
                        })
                    }
                }
                
                Divider().frame(width: 150.0)
                
                Spacer()
                    .frame(height: 20.0)
                
                HStack {
                    
                    VStack {
                        HStack{
                            firstSymbol
                        }
                        TypeDescriptionForCalculationValue(
                            value: firstValue,
                            isFirstView: isFirstView
                        )
                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack{
                            secondSymbol
                        }
                        TypeDescriptionForCalculationValue(
                            value: secondValue,
                            isFirstView: isFirstView
                        )
                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack{
                            thirdSymbol
                        }
                        TypeDescriptionForCalculationValue(
                            value: thirdValue,
                            isFirstView: isFirstView
                        )
                    }
                }
            }
        }.padding().frame(width: 350.0, height: 130.0)
    }
}

struct TypeDescriptionForCalculationValue: View {
    
    let value: String
    let isFirstView: Bool
    
    var body: some View {
        HStack{
            
            Text(value)
                .font(.system(size: 20))
            
            Spacer()
                .frame(width: 4.0)
            
            if isFirstView {
                
                VStack{
                    Spacer()
                    Text("km's")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
                
            } else {
                VStack {
                    Text("Ø").font(.system(size: 10))
                    Text("km\\m").font(.system(size: 9)).foregroundColor(.gray)
                }
            }
        }
    }
}

struct CalculationSymbol: View {
    
    var imageName: String
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    
    var isArrow: Bool
    var color: Color
    var content: String
    
    var body: some View {
        if(!isArrow) {
            Circle()
                .fill(.gray)
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: imageWidth, height: imageHeight)
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 13, height: 13)
                        .overlay(
                            Text(content)
                                .font(.system(size: 10))
                        )
                    , alignment: .bottomTrailing)
        } else {
            Circle()
                .fill(.gray)
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: imageWidth, height: imageHeight)
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 13, height: 13)
                        .overlay(
                            Image(systemName: content)
                                .resizable()
                                .frame(width: 6, height: 8)
                                .foregroundColor(color)
                        )
                    , alignment: .bottomTrailing)
        }
    }
}


// Vorschau
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

struct ContentView: View {
    
    @State var showRunSheet: Bool = false
    
    @State var runCollection = [
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
                        CalculationView(runCollection: $runCollection)
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
                AddRunSheet(showRunSheet: $showRunSheet, runCollection: $runCollection)
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

struct AddRunSheet: View {
    
    @State private var kilometerAmount: String = ""
    @State private var minutesAmount: String = ""
    @State private var secondsAmount: String = ""
    @State private var date = Date()
    
    @Binding var showRunSheet: Bool
    @Binding var runCollection: Array<Run>
    
    var body: some View {
        VStack{
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
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Anzahl der Sekunden", text: $secondsAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                DatePicker(
                    "Tag des Laufes",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                
                Spacer().frame(height: 50)
                
                Button("Hinzufügen", action: {
                    addRun(length: Double(kilometerAmount.replacing(",", with: ".")) ?? 0,
                            minutes: Int(minutesAmount) ?? 0,
                            seconds: Int(secondsAmount) ?? 0,
                            date: date)
                    showRunSheet.toggle()
                }).buttonStyle(.bordered)
                
            }.padding()
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


struct RunInsights: View {
    var run: Run
    
    var body: some View {
        VStack {
            Image(systemName: "figure.mixed.cardio")
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
            Text("Durchschnittlichen Minuten pro KM:")
            Text(run.averageMinPerKm.formatted() + " Min")
        }
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
                Image(systemName: "figure.run")
                    .resizable()
                    .frame(width: 37.0, height: 46.0)
                    .foregroundColor(.blue)
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
                    Text(run.minutes.formatted() + ":" + run.seconds.formatted())
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
                    Text("km\\m").font(.system(size: 10)).foregroundColor(.gray)
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
                        headline: "Distanz - Werte",
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
                        headline: "Zeit - Werte",
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
                .fill(
                    LinearGradient(
                        colors: [Color(.gray)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                )
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
                .fill(
                    LinearGradient(
                        colors: [Color(.gray)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                )
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

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
                                NavigationLink(destination: RunInsights(run: run)){
                                    RunListElement(run: run)
                                }
                            }
                        }
                    } else {
                        EmptyRunsListElement()
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
                                       .fill(
                                        LinearGradient(
                                            colors: [Color(.white)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
                                       )
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
        }
    }
}

struct EmptyRunsListElement: View {
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.indigo, .blue]), startPoint: .top, endPoint: .bottom)
                .mask(Image(systemName: "figure.wave")
                    .resizable()
                    .aspectRatio(contentMode: .fit))
                .frame(width: 100.0, height: 180)
                .opacity(0.75)
            
            Spacer()
                .frame(height: 80.0)
            
            VStack {
                
                Text("Du hast noch keine Läufe eingetragen!")
                    .font(.system(size: 20))
                
                Spacer()
                    .frame(height: 10.0)
                
                Text("Benutze den + Button um einen Lauf hinzuzufügen")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .frame(alignment: .center)
        .padding().frame(width: 400.0, height: 650.0)
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
                VStack(alignment: .leading) {
                    Text("Lauf")
                    Text("hinzufügen")
                }.foregroundStyle(.black)
                    .font(.system(size: 35))
                    .shadow(color: .indigo.opacity(0.5), radius: 20)
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
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    AddRunClockSymbol(unitDescription: "Min.")
                    
                    TextField("Anzahl der Minuten", text: $minutesAmount)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    AddRunClockSymbol(unitDescription: "Sek.")
                    
                    TextField("Anzahl der Sekunden", text: $secondsAmount)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
                
                DatePicker(
                    "Tag des Laufes",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                
                Spacer().frame(height: 50)
                
                Button(action: {
                    addRun(length: Double(kilometerAmount.replacing(",", with: ".")) ?? 0,
                            minutes: Int(minutesAmount) ?? 0,
                            seconds: Int(secondsAmount) ?? 0,
                            date: date)
                    showRunSheet.toggle()
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
                LinearGradient(gradient: Gradient(colors: [.indigo, .blue]), startPoint: .top, endPoint: .bottom)
                    .mask(Image(systemName: "figure.run")
                    .resizable()
                    .aspectRatio(contentMode: .fit))
                    .frame(width: 37.0, height: 46.0)
                    .opacity(0.75)
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

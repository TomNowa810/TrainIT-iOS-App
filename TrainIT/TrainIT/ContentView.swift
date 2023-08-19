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
        let lastAvg = runCollection.last?.averageMinPerKm ?? 0
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
        
        runCollection.append(
            Run(
                number: runCollection.count + 1,
                length: length,
                minutes: minutes,
                seconds: seconds,
                date: date,
                minutesTotal: minutesTotal,
                averageKmPerKm: currentAvg,
                improvement: improvementParam
            )
        )
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
            Text(run.averageMinPerKm.formatted() + " Min")
        }
    }
}

extension DateFormatter {
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.YYYY"
        return formatter
    }()
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
    
    
    var formattedAvg: String {
        let secondsTotal = Int(run.averageMinPerKm * 60);
        let minutes = (secondsTotal % 3600) / 60
        let seconds = secondsTotal % 60
        
        var secondsString = String(seconds)
        
        if(secondsString.count == 1){
            secondsString = "0" + secondsString
        }
        
        return String(minutes) + ":" + secondsString
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
    func arrowValues(run: Run) -> (
        systemName: String,
        color: Color,
        width: Double,
        height: Double
    ){
        
        switch run.improvement {
            
        case ImprovementEnum.improved :
            return ("arrow.up", .green, 12, 15)
            
        case ImprovementEnum.deteriorated:
            return ("arrow.down", .red, 12, 15)
            
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
        return roundAndDeviceByRunElements(value: sum)
    }
    
    var kmMax: Double {
        var max: Double = 0
        
        for run in runCollection {
            if(max < run.length) {
                max = run.length
            }
        }
        return roundOnTwoDecimalPlaces(value: max)
    }
    
    var kmMin: Double {
        var min: Double = runCollection.first?.length ?? 10.0
        
        for run in runCollection {
            if(min > run.length) {
                min = run.length
            }
        }
        return roundOnTwoDecimalPlaces(value: min)
    }
    
    var minAvg: Double {
        var min: Double = runCollection.first?.averageMinPerKm ?? 10.0
        
        for run in runCollection {
            if(min > run.averageMinPerKm) {
                min = run.averageMinPerKm
            }
        }
        return roundOnTwoDecimalPlaces(value: min)
    }
    
    var maxAvg: Double {
        var max: Double = 0
        
        for run in runCollection {
            if(max < run.averageMinPerKm) {
                max = run.averageMinPerKm
            }
        }
        return roundOnTwoDecimalPlaces(value: max)
    }
    
    var avgMinsPerKm: Double {
        var sum: Double = 0
        
        for run in runCollection {
            sum += run.averageMinPerKm
        }
        return roundAndDeviceByRunElements(value: sum)
    }
    
    func roundAndDeviceByRunElements(value: Double) -> Double {
        return roundOnTwoDecimalPlaces(value: (value / Double(runCollection.count)))
    }
    
    func roundOnTwoDecimalPlaces(value: Double) -> Double {
        return  round(value * 100) / 100
    }
    
    var body: some View {
        
        
        ScrollView(.horizontal, showsIndicators: true) {
            ScrollViewReader {
                value in
                
                HStack(spacing: 100) {
                    
                    CalculationView(
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
                        firstValue: self.kmAvg.formatted()
                        , secondSymbol: CalculationSymbol(
                            imageName: "road.lanes",
                            imageWidth: 22,
                            imageHeight: 20,
                            isArrow: true,
                            color: .green,
                            content: "arrow.up"
                        ),
                        secondValue: self.kmMax.formatted(),
                        thirdSymbol: CalculationSymbol(
                            imageName: "road.lanes",
                            imageWidth: 22,
                            imageHeight: 20,
                            isArrow: true,
                            color: .red,
                            content: "arrow.down"
                        ),
                        thirdValue: self.kmMin.formatted(),
                        scrollViewProxy: value
                    ).id(1)
                    
                    CalculationView(
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
                        firstValue: convertMinutesToStringForView(mins: self.avgMinsPerKm)
                        , secondSymbol: CalculationSymbol(
                            imageName: "clock.arrow.2.circlepath",
                            imageWidth: 24,
                            imageHeight: 20,
                            isArrow: true,
                            color: .green,
                            content: "arrow.up"
                        ),
                        secondValue: convertMinutesToStringForView(mins: self.minAvg),
                        thirdSymbol: CalculationSymbol(
                            imageName: "clock.arrow.2.circlepath",
                            imageWidth: 24,
                            imageHeight: 20,
                            isArrow: true,
                            color: .red,
                            content: "arrow.down"
                        ),
                        thirdValue: convertMinutesToStringForView(mins: self.maxAvg),
                        scrollViewProxy: value
                    ).id(2)
                }
            }
        }
    }
}

struct CalculationView: View {
    
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
                        RoadValueTypeDescriptionView(value: firstValue)
                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack{
                            secondSymbol
                        }
                        RoadValueTypeDescriptionView(value: secondValue)
                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack{
                            thirdSymbol
                        }
                        RoadValueTypeDescriptionView(value: thirdValue)
                    }
                }
            }
        }.padding().frame(width: 350.0, height: 130.0)
    }
}

struct RoadValueTypeDescriptionView: View {
    
    let value: String
    
    var body: some View {
        HStack{
            
            Text(value)
                .font(.system(size: 20))
            
            Spacer()
                .frame(width: 4.0)
            
            VStack{
                Spacer()
                Text("km's")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
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

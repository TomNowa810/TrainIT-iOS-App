import Foundation
import SwiftUI
import Charts

struct PieChart: View {
    @Binding var runCollection: Array<Run>
    var goalValue: Int
    
    var visualizedValues: Array<PieChartData> {
        if runCollection.count >= goalValue {
            return [.init(value: 1, color: .green)]
        } else {
            return [.init(value: runCollection.count, color: .accentColor),
                    .init(value: goalValue - runCollection.count, color: Color("GrayWhite"))]
        }
    }
    
    var body: some View {
        VStack {
            Chart {
                ForEach(visualizedValues) { value in
                    SectorMark(angle: .value("Run", value.value),
                               innerRadius: .ratio(0.7),
                               outerRadius: 120,
                               angularInset: 2.0)
                    .cornerRadius(10)
                    .foregroundStyle(value.color)
                }
            }.padding()
        }.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
    }
}

struct PieChartData: Identifiable {
    let id = UUID()
    let value: Int
    let color: Color
}

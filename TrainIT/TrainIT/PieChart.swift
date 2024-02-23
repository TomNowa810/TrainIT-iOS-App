import Foundation
import SwiftUI
import Charts

struct PieChart: View {
    @Binding var runCollection: Array<Run>
    @Binding var goalValue: Int
    var size: CGFloat
    
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
        }.frame(width: size, height: size)
    }
}

struct PieChartData: Identifiable {
    let id = UUID()
    let value: Int
    let color: Color
}

import Foundation
import SwiftUI

struct OverlayView: View {
    @Binding var runCollection: Array<Run>
    @Binding var goalValue: Int;
    
    var body: some View {
        VStack {
            ZStack {
                Color("ListBackground").ignoresSafeArea()
                
                CircleBorderView().shadow(radius: 5)
                BorderView(runCollection: $runCollection, goalValue: $goalValue).shadow(radius: 5)
                CircleWithInsightsView(runCollection: $runCollection, goalValue: $goalValue)
            }
        }
    }
}

struct BorderView: View {
    @Binding var runCollection: Array<Run>
    @Binding var goalValue: Int;
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.white)
                .frame(height: 100)
                .ignoresSafeArea()
            Spacer()
        }
    }
}

struct CircleBorderView : View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Circle()
                    .fill(.white)
                    .frame(width: 150, height: 150)
                    .ignoresSafeArea()
            }
            Spacer()
        }
    }
}

struct CircleWithInsightsView: View {
    @Binding var runCollection: Array<Run>
    @Binding var goalValue: Int
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Circle()
                    .fill(.white)
                    .frame(width: 150, height: 150)
                    .ignoresSafeArea()
                    .overlay(PieView(runCollection: $runCollection, goalValue: $goalValue))
            }
            Spacer()
        }.ignoresSafeArea()
    }
}




struct PieView: View {
    @Binding var runCollection: Array<Run>
    @Binding var goalValue: Int;
    
    @ViewBuilder
    var runCounterText: some View {
        if goalValue >= 10 && runCollection.count < 10{
            Text(runCollection.count.description).padding(3)
        } else {
            Text(runCollection.count.description)
        }
    }
    
    var body: some View {
        PieChart(runCollection: $runCollection, goalValue: $goalValue, size: 150)
            .overlay(
                HStack{
                    HStack {
                        runCounterText
                        Spacer().frame(width: 10)
                    }
                    Text("/")
                    
                    HStack {
                        Spacer().frame(width: 10)
                        Text(goalValue.description)
                    }
                }, alignment: .center)
            .ignoresSafeArea()
    }
}

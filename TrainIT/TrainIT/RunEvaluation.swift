import Foundation
import SwiftUI

struct CalculationView: View {
    
    @Binding var runCollection: Array<Run>
    
    var body: some View {
        let (kmMax, kmAvg, kmMin, minAvg, maxAvg, avgMinsPerKm) = calculateRunValues(runCollectionBinding: $runCollection)
        
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader {
                value in
                
                HStack(spacing: 100) {
                    
                    CalculationPageView(
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
                    )
                    
                    CalculationPageView(
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
                    )
                }.scrollTargetLayout()
            }
        }.scrollTargetBehavior(.viewAligned)
    }
}

struct CalculationViewRefactored: View {
    
    @Binding var runCollection: Array<Run>
    
    var body: some View {
        let (kmMax, kmAvg, kmMin, minAvg, maxAvg, avgMinsPerKm) = calculateRunValues(runCollectionBinding: $runCollection)
        
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader {
                value in
                
                HStack(spacing: 100) {
                    
                    CalculationPageViewRefactored(
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
                    )
                    
                    CalculationPageViewRefactored(
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
                    )
                }.scrollTargetLayout()
            }
        }.scrollTargetBehavior(.viewAligned)
    }
}


struct CalculationPageValueStructure: View {
    
    let headline: String
    let isFirstView: Bool
    
    let firstSymbol: CalculationSymbol
    let firstValue: String
    
    let secondSymbol: CalculationSymbol
    let secondValue: String
    
    let thirdSymbol: CalculationSymbol
    let thirdValue: String
    
    var body: some View {
        HStack {
            
            Spacer().frame(width: 10)
            
            VStack {
                
                HStack {
                    Spacer()
                    ScrollViewIndexPoints(isFirstObject: isFirstView)
                }
                
                HStack {
                    Spacer()
                    
                    Text(headline)
                        .font(.subheadline)
                        .foregroundColor(.indigo)
                        .opacity(0.85)
                    
                    Text("- Werte")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
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
            
            Spacer().frame(width: 10)
            
        }
    }
}

struct CalculationPageValueStructureRefactored: View {
    
    let headline: String
    let isFirstView: Bool
    
    let firstSymbol: CalculationSymbol
    let firstValue: String
    
    let secondSymbol: CalculationSymbol
    let secondValue: String
    
    let thirdSymbol: CalculationSymbol
    let thirdValue: String
    
    var body: some View {
        HStack {
            
            ZStack {
                
                //HStack {
                //    Spacer()
                //    ScrollViewIndexPoints(isFirstObject: isFirstView)
                //}
                
                HStack {
                    Rectangle()
                        .frame(width: 85, height: 150)
                        .cornerRadius(15)
                        .scaledToFit()
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                HStack {
                    Circle()
                        .fill(.gray)
                    //.frame(width: 30, height: 30)
                        .overlay(
                            HStack {
                                
                                Image(systemName: "road.lanes")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.white)
                                //.scaledToFit()
                                Spacer().frame(width: 10)
                                
                            }).scaledToFit()
                    Spacer()
                }
                
                VStack(spacing: 20) {
                    
                    HStack {
                        Spacer().frame(width: 30)
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 12, height: 18)
                            .foregroundColor(.green)
                        TypeDescriptionForCalculationValue(value: secondValue, isFirstView: true)
                    }.shadow(color: .green.opacity(0.2), radius: 1)
                    
                    HStack {
                        Spacer().frame(width: 60)
                        Text("Ø").font(.system(size: 20))
                        TypeDescriptionForCalculationValue(value: firstValue, isFirstView: true)
                    }.shadow(color: .gray.opacity(0.2), radius: 1)
                    
                    HStack {
                        Spacer().frame(width: 30)
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 12, height: 18)
                            .foregroundColor(.red)
                        TypeDescriptionForCalculationValue(value: thirdValue, isFirstView: true)
                    }.shadow(color: .red.opacity(0.2), radius: 1)
                }
                
                

                

                
                
            }
            
        }
    }
}

struct CalculationPageView: View {
    
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
        Rectangle()
            .fill(.white)
            .cornerRadius(15)
            .frame(width: 350, height: 150)
            .overlay(CalculationPageValueStructure(headline: headline, isFirstView: isFirstView,
                                                   firstSymbol: firstSymbol, firstValue: firstValue,
                                                   secondSymbol: secondSymbol, secondValue: secondValue,
                                                   thirdSymbol: thirdSymbol, thirdValue: thirdValue))
            .padding()
            .containerRelativeFrame(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/, count: 1, spacing:  350.0)
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3,
                                 y: phase.isIdentity ? 1.0 : 0.3)
                    .offset(y: phase.isIdentity ? 0: 50)
            }
    }
}

struct CalculationPageViewRefactored: View {
    
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
        Rectangle()
            .fill(.white)
            .cornerRadius(15)
            .frame(width: 350, height: 150)
            .overlay(CalculationPageValueStructureRefactored(headline: headline, isFirstView: isFirstView,
                                                             firstSymbol: firstSymbol, firstValue: firstValue,
                                                             secondSymbol: secondSymbol, secondValue: secondValue,
                                                             thirdSymbol: thirdSymbol, thirdValue: thirdValue))
            .padding()
            .containerRelativeFrame(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/, count: 1, spacing:  350.0)
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3,
                                 y: phase.isIdentity ? 1.0 : 0.3)
                    .offset(y: phase.isIdentity ? 0: 50)
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
    
    @ViewBuilder
    var overlayContent: some View {
        if !isArrow {
            Text(content).font(.system(size: 10))
        } else {
            Image(systemName: content)
                .resizable()
                .frame(width: 6, height: 8)
                .foregroundColor(color)
        }
    }
    
    var body: some View {
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
                        overlayContent
                    )
                , alignment: .bottomTrailing)
    }
}

struct TypeDescriptionForCalculationValue: View {
    
    let value: String
    let isFirstView: Bool
    
    
    @ViewBuilder
    var descriptionBuilder: some View {
        if isFirstView {
            VStack{
                Spacer().frame(height: 7)
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
    
    var body: some View {
        HStack{
            Text(value)
                .font(.system(size: 20))
            
            Spacer()
                .frame(width: 4.0)
            
            descriptionBuilder
        }
    }
}

struct ScrollViewIndexPoints: View {
    var isFirstObject: Bool
    
    var body: some View {
        let firstColor: Color = isFirstObject ? .gray : Color("GrayWhite")
        let secondColor: Color = isFirstObject ? Color("GrayWhite") : .gray
        
        HStack(spacing: 5) {
            Circle()
                .fill(firstColor)
                .frame(width: 6)
            
            Circle()
                .fill(secondColor)
                .frame(width: 6)
        }
    }
}

//
//  DesignUtils.swift
//  TrainIT
//
//  Created by Tom Nowakowski on 20.09.23.
//

import Foundation
import SwiftUI

var defaultGradient: LinearGradient {
    LinearGradient(
        gradient: Gradient(colors: [.indigo, .blue]),
        startPoint: .top,
        endPoint: .bottom
    )
}

struct FigureOnListElement: View {
    var isWithTrophy: Bool
    
    var body: some View {
        if isWithTrophy {
            DefaultFigure()
                .overlay(
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.white, Color("GrayWhite")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 16, height: 16)
                            .overlay(Image(systemName: "trophy.fill")
                                .resizable()
                                .frame(width: 10, height: 12)
                                .foregroundStyle(LinearGradient(
                                    gradient: Gradient(colors: [.yellow, Color("TrophyPrimary")]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )))
                         , alignment: .bottomTrailing)
        } else {
            DefaultFigure()
        }
    }
}

private struct DefaultFigure: View {
    var body: some View {
        Rectangle()
            .fill(.white)
            .frame(width: 35.0, height: 46.0)
            .overlay(
                defaultGradient
                    .mask(Image(systemName: "figure.run")
                        .resizable()
                        .aspectRatio(contentMode: .fit))
                    .frame(width: 37.0, height: 46.0)
                    .opacity(0.75)
            )
    }
}

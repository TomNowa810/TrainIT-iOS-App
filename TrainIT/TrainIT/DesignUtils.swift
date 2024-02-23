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

var calculationGradient: LinearGradient {
    LinearGradient(
        gradient: Gradient(colors: [.red, .orange]),
        startPoint: .top,
        endPoint: .bottom
    )
}

struct DefaultFigure: View {
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

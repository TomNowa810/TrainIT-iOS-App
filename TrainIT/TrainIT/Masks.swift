//
//  Masks.swift
//  TrainIT
//
//  Created by Tom Nowakowski on 30.08.23.
//

import Foundation
import SwiftUI

struct OnlyOneRunMask: View {
    var body: some View {
        Section {
            ZStack {
                BackgroundColorGradient()
                
                VStack {
                    Spacer().frame(height: 100.0)
                    
                    LinearGradient(gradient: Gradient(colors: [.indigo, .blue]), startPoint: .top, endPoint: .bottom)
                        .mask(Image(systemName: "figure.strengthtraining.functional")
                            .resizable()
                            .aspectRatio(contentMode: .fit))
                        .frame(width: 100.0, height: 180)
                        .opacity(0.75)
                    
                    Spacer()
                        .frame(height: 80.0)
                    
                    VStack {
                        HStack(spacing: 0) {
                            Text("Erhalte eine ")
                            Text("Auswertungsleiste")
                                .foregroundColor(.indigo)
                        }
                        Text("wenn du noch einen")
                        
                        HStack(spacing: 0) {
                            Text("Lauf ")
                            Text("hinzufügst!")
                        }
                        Spacer()
                            .frame(height: 200.0)
                    }
                    .frame(alignment: .center)
                    .padding().frame(width: 400.0, height: 140.0)
                    .foregroundColor(.black)
                    .font(.system(size: 22))
                    .fontWeight(/*@START_MENU_TOKEN@*/.thin/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

struct EmptyRunsListMask: View {
    var body: some View {
        ZStack {
            BackgroundColorGradient()
            
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
                        .fontWeight(/*@START_MENU_TOKEN@*/.thin/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                        .frame(height: 10.0)
                    
                    HStack(spacing: 4) {
                        Text("Benutze den")
                        Text("+").foregroundColor(.indigo)
                        Text("Button um einen Lauf hinzuzufügen")
                    }.font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .frame(alignment: .center)
            .padding().frame(width: 400.0, height: 625.0)
            
        }
    }
}

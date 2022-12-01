//
//  testview.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/28/22.
//

import SwiftUI

struct HardView: View {
    @ObservedObject var CurrentGame: Game
    @State var Letter: LetterModel
    @State var location: CGPoint
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil // 1
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location // 3
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location // 2
            }
    }
    
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.mint)
                Text(Letter.letter)
                    .rotation3DEffect(.degrees(Letter.isRotated ? 180 : 0),axis:(x:0,y:1,z:0))
            }
            .onTapGesture {
                Letter.isRotated.toggle()
                if CurrentGame.checkIfWonGame() {
                    CurrentGame.showWinScreen()
                }
            }
            .animation(.default, value: Letter.isRotated)
            .font(.largeTitle)
            .foregroundColor(.black)
            .position(location)
            .gesture(
                simpleDrag.simultaneously(with: fingerDrag)
            )
            .overlay {
                if let fingerLocation = fingerLocation {
                    Circle()
                        .stroke(Color.green, lineWidth: 2)
                        .frame(width: 44, height: 44)
                        .position(fingerLocation)
                }
            }
        }
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        HardView(CurrentGame: Game(), Letter: LetterModel(letter: "f", isRotated: true, positions: [1]), location: CGPoint(x: 50, y: 50))
    }
}

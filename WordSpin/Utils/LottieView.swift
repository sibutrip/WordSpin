//
//  LottieView.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/28/22.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var animationName: String
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        let animation = Animation.named(animationName)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


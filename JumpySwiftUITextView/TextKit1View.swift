//
//  TextKit1ScrollView.swift
//  JumpySwiftUITextView
//
//  Created by Joseph Cheung on 1/2/2023.
//

import SwiftUI

struct TextKit1View: UIViewRepresentable {
    @Binding var activeTab: Int
    
    func makeUIView(context: Context) -> some UIView {
        // TextKit1 UITextView
        let view = UITextView(usingTextLayoutManager: false)
        view.backgroundColor = .tertiarySystemFill
        view.text = sampleContent
        view.delegate = context.coordinator
        
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let view = uiView as? UITextView, activeTab == 1 else { return }
        
        let p = CGPoint(x: 0, y: 2380)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
            // TextKit1 ensure layout
            view.layoutManager.ensureLayout(for: view.textContainer)

            // Maximum content offset in this demo is (0.0, 2380.0).
            // We expect scroll view to scroll to bottom, however it doesn't move at all if animated is set to false
            view.setContentOffset(p, animated: false)
            
            // Setting animated to true can scroll the scroll view to bottom
            // view.setContentOffset(p, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        let parent: TextKit1View
        
        init(_ parent: TextKit1View) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("*** contentOffset: \(scrollView.contentOffset)")
        }
    }
}



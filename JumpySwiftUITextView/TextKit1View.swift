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
        print("*** Show Tab 1: TextKit1View")
        
        let p = CGPoint(x: 0, y: 2500)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
            // TextKit1 ensure layout
            view.layoutManager.ensureLayout(for: view.textContainer)

            // Maximum content offset in this demo is (0.0, 2384.0).
            print(">>> Show Tab 1: TextKit1View to offset \(p)")
            // Able to scroll to given content offset on first display
            view.setContentOffset(p, animated: false)
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
            print("*** Tab 1: contentOffset: \(scrollView.contentOffset)")
        }
    }
}



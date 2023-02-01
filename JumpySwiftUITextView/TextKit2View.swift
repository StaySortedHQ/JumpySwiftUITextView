//
//  TextKit2View.swift
//  JumpySwiftUITextView
//
//  Created by Joseph Cheung on 1/2/2023.
//

import SwiftUI

// TextKit 2 setContentOffset
struct TextKit2View: UIViewRepresentable {
    @Binding var activeTab: Int
 
    func makeUIView(context: Context) -> some UIView {
        // TextKit2 UITextView
        let view = UITextView(usingTextLayoutManager: true)
        view.backgroundColor = .tertiarySystemFill
        view.text = sampleContent
        view.delegate = context.coordinator
        
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let view = uiView as? UITextView, activeTab == 2 else { return }
        print("*** Show Tab 2: TextKit2View")

        let p = CGPoint(x: 0, y: 2500)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
            // TextKit2 ensure layout
            guard let textContentStorage = view.textContentStorage,
                  let textLayoutManager = view.textLayoutManager
            else { return }
            
            textLayoutManager.ensureLayout(for: textContentStorage.documentRange)

            // Maximum content offset in this demo is (0.0, 2384.0).
            print(">>> Show Tab 2: TextKit2View to offset \(p)")
            // It doesn't scroll to given contentOffset on first display
            // - contentOffset is reset to zero after several iterations (see console log)
            // However, this becomes possible if text view is shown second time (by switching tab) and going forward.
            view.setContentOffset(p, animated: false)
            
            // Setting animated to true can scroll the text view to bottom on first display
//            view.setContentOffset(p, animated: true)
            
            // Using adjustViewport has no effect
//            textLayoutManager.textViewportLayoutController.adjustViewport(byVerticalOffset: p.y)
            
            // Using reloaceViewport has no effect
//            textLayoutManager.textViewportLayoutController.relocateViewport(to: textContentStorage.documentRange.endLocation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        let parent: TextKit2View
        
        init(_ parent: TextKit2View) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("*** Tab 2: contentOffset: \(scrollView.contentOffset)")
        }
    }
}

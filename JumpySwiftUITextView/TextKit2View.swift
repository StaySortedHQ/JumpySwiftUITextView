//
//  TextKit2View.swift
//  JumpySwiftUITextView
//
//  Created by Joseph Cheung on 1/2/2023.
//

import Combine
import SwiftUI

// TextKit 2 setContentOffset
struct TextKit2View: UIViewRepresentable {
    enum Action {
        case scrollUsingContentOffset
        case scrollUsingAdjustViewport
        case scrollUsingRelocateViewport
    }
    @Binding var activeTab: Int
    var action: AnyPublisher<Action, Never>
 
    func makeUIView(context: Context) -> some UIView {
        print("*** Make Tab 2")
        // TextKit2 UITextView
        let view = UITextView(usingTextLayoutManager: true)
        view.backgroundColor = .tertiarySystemFill
        view.text = sampleContent
        view.delegate = context.coordinator
        action.sink { action in
            switch action {
            case .scrollUsingContentOffset:
                self.scrollUsingContentOffset(view)
            case .scrollUsingAdjustViewport:
                self.scrollUsingAdjustViewport(view)
            case .scrollUsingRelocateViewport:
                self.scrollUsingRelocateViewport(view)
            }
        }
        .store(in: &context.coordinator.cancellables)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let _ = uiView as? UITextView, activeTab == 2 else { return }
        print("*** Show Tab 2: TextKit2View")
    }
    
    // ===============
    // MARK: - Helpers
    // ===============
    
    private func scrollUsingContentOffset(_ textView: UITextView) {
        guard let textContentStorage = textView.textContentStorage,
              let textLayoutManager = textView.textLayoutManager
        else { return }
        
        textLayoutManager.ensureLayout(for: textContentStorage.documentRange)
        textView.layoutIfNeeded()
        
        // Setting animated to true can scroll the text view to bottom
        // If animated is set to false, it can only work after running this the second time.
        let p = CGPoint(x: 0, y: 2800)
        textView.setContentOffset(p, animated: false)
    }
    
    private func scrollUsingAdjustViewport(_ textView: UITextView) {
        guard let textContentStorage = textView.textContentStorage,
              let textLayoutManager = textView.textLayoutManager
        else { return }
        
        textLayoutManager.ensureLayout(for: textContentStorage.documentRange)
        textView.layoutIfNeeded()
        
        // Using adjustViewport has no effect
        let p = CGPoint(x: 0, y: 2800)
        textLayoutManager.textViewportLayoutController.adjustViewport(byVerticalOffset: p.y)
    }
    
    private func scrollUsingRelocateViewport(_ textView: UITextView) {
        guard let textContentStorage = textView.textContentStorage,
              let textLayoutManager = textView.textLayoutManager
        else { return }
        
        textLayoutManager.ensureLayout(for: textContentStorage.documentRange)
        textView.layoutIfNeeded()
        
        // Using reloaceViewport has no effect
        textLayoutManager.textViewportLayoutController.relocateViewport(to: textContentStorage.documentRange.endLocation)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        var cancellables: Set<AnyCancellable> = []
        
        let parent: TextKit2View
        
        init(_ parent: TextKit2View) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("*** Tab 2: contentOffset: \(scrollView.contentOffset)")
        }
    }
}

struct TextKit2ViewWrapper: View {
    @Binding var activeTab: Int
    private var action = PassthroughSubject<TextKit2View.Action, Never>()
    
    init(activeTab: Binding<Int>) {
        self._activeTab = activeTab
    }
    
    var body: some View {
        VStack {
            if activeTab == 2 {
                TextKit2View(
                    activeTab: $activeTab,
                    action: action.eraseToAnyPublisher()
                )
            }
            
            VStack {
                Button("Option 1: Scroll using setContentOffset") {
                    action.send(.scrollUsingContentOffset)
                }
                .padding(.vertical, 4)
                
                Button("Option 2: Scroll using adjustViewport") {
                    action.send(.scrollUsingAdjustViewport)
                }
                .padding(.vertical, 4)
                
                Button("Option 3: Scroll using relocateViewport") {
                    action.send(.scrollUsingRelocateViewport)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

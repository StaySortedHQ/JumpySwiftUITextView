//
//  TextKit1ScrollView.swift
//  JumpySwiftUITextView
//
//  Created by Joseph Cheung on 1/2/2023.
//

import Combine
import SwiftUI

struct TextKit1View: UIViewRepresentable {
    enum Action {
        case scrollUsingContentOffset
    }
    @Binding var activeTab: Int
    var action: AnyPublisher<Action, Never>
    
    func makeUIView(context: Context) -> some UIView {
        // TextKit1 UITextView
        let view = UITextView(usingTextLayoutManager: false)
        view.backgroundColor = .tertiarySystemFill
        view.text = sampleContent
        view.delegate = context.coordinator
        action.sink { action in
            switch action {
            case .scrollUsingContentOffset:
                self.scrollUsingContentOffset(view)
            }
        }
        .store(in: &context.coordinator.cancellables)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let _ = uiView as? UITextView, activeTab == 1 else { return }
        print("*** Show Tab 1: TextKit1View")
    }

    // ===============
    // MARK: - Helpers
    // ===============
    
    private func scrollUsingContentOffset(_ textView: UITextView) {
        // TextKit1 ensure layout
        textView.layoutManager.ensureLayout(for: textView.textContainer)

        // Setting animated to true can scroll the text view to bottom on first display
        let p = CGPoint(x: 0, y: 2800)
        // Maximum content offset in this demo is (0.0, 2384.0).
        print(">>> Show Tab 1: TextKit1View to offset \(p)")
        textView.setContentOffset(p, animated: false)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        var cancellables: Set<AnyCancellable> = []
        
        let parent: TextKit1View
        
        init(_ parent: TextKit1View) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("*** Tab 1: contentOffset: \(scrollView.contentOffset)")
        }
    }
}

struct TextKit1ViewWrapper: View {
    @Binding var activeTab: Int
    private var action = PassthroughSubject<TextKit1View.Action, Never>()

    init(activeTab: Binding<Int>) {
        self._activeTab = activeTab
    }

    var body: some View {
        VStack {
            if activeTab == 1 {
                TextKit1View(
                    activeTab: $activeTab,
                    action: action.eraseToAnyPublisher()
                )
            }
            VStack {
                Button("Scroll using setContentOffset") {
                    action.send(.scrollUsingContentOffset)
                }
                .padding(.vertical, 4)
            }
        }
    }
}


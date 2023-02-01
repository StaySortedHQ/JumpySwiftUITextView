//
//  TextKit1AdjustView.swift
//  JumpySwiftUITextView
//
//  Created by Harry Ng on 1/2/2023.
//

import Combine
import SwiftUI

class CustomUITextView1: UITextView {
    private var allowsScrolling: Bool = true
    
    override var contentOffset: CGPoint {
        get { super.contentOffset }
        set {
            guard allowsScrolling else { return }
            super.contentOffset = newValue
            print("*** Tab 3: didSet contentOffset: \(newValue)")
        }
    }
    
    func scroll() {
        print("*** scroll()")
        layoutManager.ensureLayout(for: textContainer)
        self.layoutIfNeeded()
        let offset = CGPoint(x: 0, y: 2800)
        self.setContentOffset(offset, animated: false)
    }
    
    func updateText() {
        updateTextUsingCaretRect()
    }
    
    private func updateTextUsingCaretRect() {
        // Get caret rect before text update
        let beforeLocation = self.selectedRange.location
        let before = self.caretRect(for: beforeLocation)
        let globalBefore = self.convert(before, to: nil)
        
        updateTextContent()
        
        ensureLayout()
        
        // Get caret rect after text update
        let afterLocation = self.selectedRange.location
        let after = self.caretRect(for: afterLocation)
        let globalAfter = self.convert(after, to: nil)

        let dy = globalAfter.minY - globalBefore.minY

        if dy != 0 {
            // Adjust textView contentOffset
            let newOffset = self.contentOffset.offset(dy: dy)
            print("*** newOffset: \(newOffset) - before: \(globalBefore.minY) - after: \(globalAfter.minY) - dy: \(dy)")
            
            self.setContentOffset(newOffset, animated: false)
        }
    }
    
    // ===============
    // MARK: - Helpers
    // ===============

    private func updateTextContent() {
        textStorage.beginEditing()
        let text = "built-in text controls, the components in the TextKit stack"
        let count = text.count
        
        let affectedRanges = [
            NSRange(location: 9, length: 3),
        ]
        
        for affectedRange in affectedRanges {
            textStorage.replaceCharacters(in: affectedRange, with: text)
            let prevRange = selectedRange
            selectedRange = .init(location: prevRange.location + count - 3, length: prevRange.length)
        }
        textStorage.endEditing()
    }
    
    private func ensureLayout() {
        layoutManager.ensureLayout(for: textContainer)
        self.layoutIfNeeded()
    }
        
}

// TextKit 1 setContentOffset
struct CustomTextView1: UIViewRepresentable {
    enum Action {
        case scroll
        case updateText
    }
    @Binding var activeTab: Int
    var action: AnyPublisher<Action, Never>
    
    func makeUIView(context: Context) -> some UIView {
        // TextKit2 UITextView
        let view = CustomUITextView1()
        let _ = view.layoutManager
        view.backgroundColor = .tertiarySystemFill
        view.text = sampleContent
        view.delegate = context.coordinator
        action.sink { action in
            switch action {
            case .scroll:
                view.scroll()
            case .updateText:
                view.updateText()
            }
        }
        .store(in: &context.coordinator.cancellables)
        
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let _ = uiView as? UITextView, activeTab == 3 else { return }
        print("*** Show Tab 3: TextKit1AdjustView")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        let parent: CustomTextView1
        var cancellables: Set<AnyCancellable> = []
        init(_ parent: CustomTextView1) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("*** Tab 3: contentOffset: \(scrollView.contentOffset)")
        }
    }
}
struct TextKit1AdjustView: View {
    @Binding var activeTab: Int
    private var action = PassthroughSubject<CustomTextView1.Action, Never>()
    
    init(activeTab: Binding<Int>) {
        self._activeTab = activeTab
    }
    
    var body: some View {
        VStack {
            if activeTab == 3 {
                CustomTextView1(
                    activeTab: $activeTab,
                    action: action.eraseToAnyPublisher()
                )
            }
            VStack {
                Button("Step 1: Scroll") {
                    action.send(.scroll)
                }
                .padding(.vertical, 4)
                Button("Step 2: Update text") {
                    action.send(.updateText)
                }
                .padding(.vertical, 4)
            }
        }
    }
}


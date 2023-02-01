//
//  TextKit2AdjustView.swift
//  JumpySwiftUITextView
//
//  Created by Joseph Cheung on 1/2/2023.
//

import Combine
import SwiftUI

class CustomUITextView: UITextView {
    private var allowsScrolling: Bool = true
    
    override var contentOffset: CGPoint {
        get { super.contentOffset }
        set {
            guard allowsScrolling else { return }
            super.contentOffset = newValue
            print("*** Tab 4: didSet contentOffset: \(newValue)")
        }
    }
    
    func scroll() {
        guard let textContentStorage = self.textContentStorage,
              let textLayoutManager = self.textLayoutManager
        else { return }
        print("*** scroll()")
        textLayoutManager.ensureLayout(for: textContentStorage.documentRange)
        self.layoutIfNeeded()
        let offset = CGPoint(x: 0, y: 2800)
        self.setContentOffset(offset, animated: false)
    }
    
    func updateText() {
//        updateTextUsingCaretRect()
        updateTextUsingEnumerateTextSegments()
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
    
    private func updateTextUsingEnumerateTextSegments() {
        guard let textLayoutManager = self.textLayoutManager else { return }
        let before = textLayoutManager.rectOfFirstTextSegment(in: self.selectedRange)
        let globalBefore = self.convert(before, to: nil)

        updateTextContent()
        
        ensureLayout()
        
        let after = textLayoutManager.rectOfFirstTextSegment(in: self.selectedRange)
        let globalAfter = self.convert(after, to: nil)

        let dy = globalAfter.minY - globalBefore.minY

        if dy != 0 {
            // Adjust textView contentOffset
            let newOffset = self.contentOffset.offset(dy: dy)
            print("*** newOffset: \(newOffset) - before: \(globalBefore.minY) - after: \(globalAfter.minY) - dy: \(dy)")
            
//            self.textView.allowsScrolling = false
//            self.textView.isScrollEnabled = false
//            self.textView.allowsScrolling = true
            self.setContentOffset(newOffset, animated: false)
//            self.textView.isScrollEnabled = true
        }
    }
    
    // ===============
    // MARK: - Helpers
    // ===============

    private func updateTextContent() {
        self.textContentStorage?.performEditingTransaction { [weak self] in
            guard let textView = self else { return }
            let text = "built-in text controls, the components in the TextKit stack"
            let count = text.count
            
            let affectedRanges = [
                NSRange(location: 9, length: 3),
            ]
            
            for affectedRange in affectedRanges {
                textView.textStorage.replaceCharacters(in: affectedRange, with: text)
                let prevRange = textView.selectedRange
                textView.selectedRange = .init(location: prevRange.location + count - 3, length: prevRange.length)
            }
        }
    }
    
    private func ensureLayout() {
        let textRange = self.textContentStorage!.textRange(from: self.textStorage.range)
        self.textLayoutManager?.ensureLayout(for: textRange)
        self.layoutIfNeeded()
    }
    
}

// TextKit 2 setContentOffset
struct CustomTextView: UIViewRepresentable {
    enum Action {
        case scroll
        case updateText
    }
    @Binding var activeTab: Int
    var action: AnyPublisher<Action, Never>
    
    func makeUIView(context: Context) -> some UIView {
        // TextKit2 UITextView
        let view = CustomUITextView()
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
        print("*** Show Tab 4: TextKit2AdjustView")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        let parent: CustomTextView
        var cancellables: Set<AnyCancellable> = []
        init(_ parent: CustomTextView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("*** Tab 4: contentOffset: \(scrollView.contentOffset)")
        }
    }
}

struct TextKit2AdjustView: View {
    @Binding var activeTab: Int
    private var action = PassthroughSubject<CustomTextView.Action, Never>()
    
    init(activeTab: Binding<Int>) {
        self._activeTab = activeTab
    }
    
    var body: some View {
        VStack {
            if activeTab == 4 {
                CustomTextView(
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

struct TextKit2AdjustView_Previews: PreviewProvider {
    static var previews: some View {
        TextKit2AdjustView(activeTab: .constant(3))
    }
}

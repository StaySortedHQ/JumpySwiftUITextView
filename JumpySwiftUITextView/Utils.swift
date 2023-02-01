//
//  Utils.swift
//  JumpySwiftUITextView
//
//  Created by Joseph Cheung on 1/2/2023.
//

import UIKit

extension UITextView {
    var textContentStorage: NSTextContentStorage? {
        return textLayoutManager?.textContentManager as? NSTextContentStorage
    }

    func caretRect(for location: Int) -> CGRect {
        guard let position = position(from: beginningOfDocument, offset: location) else {
            fatalError("Could not find position")
        }
        return caretRect(for: position)
    }    
}

private let textColor = UIColor.label

extension NSTextStorage {
    // Load the surrounding text for the exclusion path.
    func loadSampleText() {
        guard let fileURL = Bundle.main.url(forResource: "Sample", withExtension: "rtf") else {
            fatalError("Failed to find Sample.rtf in the app bundle.")
        }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf]
        guard let sampleText = try? NSAttributedString(url: fileURL, options: options, documentAttributes: nil) else {
            fatalError("Failed to load sample text.")
        }
        replaceCharacters(in: NSRange(location: 0, length: length), with: sampleText)
        addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: length))
    }
}

public extension NSTextContentManager {
    /// Convert NSRange to NSTextRange
    /// From wwdc2022-10090 - What's new in TextKit and text views
    func textRange(from nsRange: NSRange) -> NSTextRange {
        let startLocation = location(documentRange.location, offsetBy: nsRange.location)!
        let endLocation = location(startLocation, offsetBy: nsRange.length)
        return NSTextRange(location: startLocation, end: endLocation)!
    }
}

public extension NSTextLayoutManager {
    var textContentStorage: NSTextContentStorage? {
        textContentManager as? NSTextContentStorage
    }

    func rectOfFirstTextSegment(in range: NSRange) -> CGRect {
        guard let textContentStorage else { return .infinite }
        let textRange = textContentStorage.textRange(from: range)
        var result: CGRect = .infinite
        enumerateTextSegments(in: textRange, type: .standard) {
            textRange, rect, baselineOffset, textContainer in
            result = rect
            return false
        }
        return result
    }
    
}

extension NSAttributedString {
    var range: NSRange { NSRange(location: 0, length: length) }
}

extension CGPoint {
    func offset(dy: CGFloat) -> Self {
        CGPoint(x: x, y: y + dy)
    }
}

//
//  RichTextCoordinator+SubscriptionsTests.swift
//  OribiRichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI
import XCTest

@testable import RichTextKit

class RichTextCoordinator_SubscriptionsTests: XCTestCase {
    
    var text: NSAttributedString!
    var textBinding: Binding<NSAttributedString>!
    var textView: RichTextView!
    var textContext: RichTextContext!
    var coordinator: RichTextCoordinator!

    override func setUp() {
        text = NSAttributedString(string: "foo bar baz")
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        textView = RichTextView()
        textContext = RichTextContext()
        coordinator = RichTextCoordinator(
            text: textBinding,
            textView: textView,
            context: textContext)
        textView.selectedRange = NSRange(location: 0, length: 1)
        textView.setCurrentRichTextAlignment(to: .justified)
    }


    func testTextCoordinatorIsNeededForUpdatesToTakePlace() {
        XCTAssertNotNil(coordinator)
    }


    func testFontNameChangesUpdatesTextView() {
        XCTAssertNotEqual(textView.currentFontName, "Arial")
        textContext.fontName = ""

        eventually {
            #if os(iOS) || os(tvOS)
            XCTAssertEqual(self.textView.currentFontName, ".SFUI-Regular")
            #elseif os(macOS)
            XCTAssertEqual(self.textView.currentFontName, "Helvetica")
            #endif
        }
    }


    func testFontSizeChangesUpdatesTextView() {
        XCTAssertNotEqual(textView.currentFontSize, 666)
        textContext.fontSize = 666
        XCTAssertEqual(textView.currentFontSize, 666)
    }


    func testFontSizeDecrementUpdatesTextView() {
        textView.setCurrentFontSize(to: 666)
        XCTAssertEqual(textView.currentFontSize, 666)
        textContext.decrementFontSize()
        // XCTAssertEqual(textView.currentFontSize, 665)    TODO: Why is incorrect?
    }


    func testFontSizeIncrementUpdatesTextView() {
        textView.setCurrentFontSize(to: 666)
        XCTAssertEqual(textView.currentFontSize, 666)
        textContext.incrementFontSize()
        // XCTAssertEqual(textView.currentFontSize, 667)    TODO: Why is incorrect?
    }


    func testHighlightedRangeUpdatesTextView() {
        textView.highlightingStyle = RichTextHighlightingStyle(
            backgroundColor: .yellow,
            foregroundColor: .red)
        let range = NSRange(location: 4, length: 3)
        textContext.highlightRange(range)
        let attr = textView.richTextAttributes(at: range)
        let back = attr[.backgroundColor] as? ColorRepresentable
        let fore = attr[.foregroundColor] as? ColorRepresentable
        XCTAssertEqual(back, ColorRepresentable(textView.highlightingStyle.backgroundColor))
        XCTAssertEqual(fore, ColorRepresentable(textView.highlightingStyle.foregroundColor))
    }


    func testIsBoldUpdatesTextView() {
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.bold))
        textContext.isBold = true
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.bold))
    }


    func testIsItalicUpdatesTextView() {
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.italic))
        textContext.isItalic = true
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.italic))
    }


    func testIsUnderlinedUpdatesTextView() {
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.underlined))
        textContext.isUnderlined = true
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.underlined))
    }


    func testSelectedRangeUpdatesTextView() {
        let range = NSRange(location: 4, length: 3)
        textContext.selectedRange = range
         XCTAssertEqual(textView.selectedRange, range)
    }


    func testTextAlignmentUpdatesTextView() {
        textView.setCurrentRichTextAlignment(to: .left)
        XCTAssertEqual(textView.currentRichTextAlignment, .left)
        textContext.alignment = .right
        XCTAssertEqual(textView.currentRichTextAlignment, .right)
    }
}
#endif

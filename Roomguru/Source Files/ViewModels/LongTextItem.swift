//
//  LongTextItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Async

class LongTextItem: GroupItem {
    var text: String?
    var placeholder: String
    
    var attributedText: NSAttributedString? {
        if let text = text where !text.isEmpty {
            return NSAttributedString(string: text, attributes: textAttributes)
        }
        return nil
    }
    var attributedPlaceholder: NSAttributedString {
        return NSAttributedString(string: placeholder, attributes: placeholderAttributes)
    }
        
    var onValueChanged: StringBlock?
    
    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(title: "", category: .LongText)
    }
    
    private static let textFont = UIFont.systemFontOfSize(17.0)
    
    private let placeholderAttributes = [
        NSFontAttributeName: textFont,
        NSForegroundColorAttributeName: UIColor.systemPlaceholder()
    ]
    
    private let textAttributes = [
        NSFontAttributeName: textFont,
        NSForegroundColorAttributeName: UIColor.blackColor()
    ]
}

extension LongTextItem: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.attributedText == attributedPlaceholder {
            Async.main {
                textView.selectedRange = NSMakeRange(0, 0);
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView.attributedText == attributedPlaceholder {
            textView.attributedText = NSAttributedString(string: "", attributes: textAttributes)
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.length == 1 {
            textView.attributedText = NSAttributedString(string: textView.text, attributes: textAttributes)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        text = textView.text
        onValueChanged?(string: textView.text)
        
        if textView.text.isEmpty {
            textView.attributedText = attributedPlaceholder
        }
    }
}

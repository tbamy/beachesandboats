//
//  AttributedLabelDelegate.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 29/08/2025.
//


import UIKit

protocol AttributedLabelDelegate: AnyObject {
    func didTapOnLink(_ url: URL)
}

class AttributedLabel: UILabel {
    
    weak var delegate: AttributedLabelDelegate?
    private var linkRanges: [NSRange: URL] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        numberOfLines = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(text: String, links: [String: URL]) {
        let attributed = NSMutableAttributedString(string: text)
        let fullText = text as NSString
        linkRanges.removeAll()
        
        for (word, url) in links {
            let range = fullText.range(of: word)
            if range.location != NSNotFound {
                attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                attributed.addAttribute(.foregroundColor, value: UIColor.beachBlue, range: range)
                linkRanges[range] = url
            }
        }
        
        self.attributedText = attributed
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let text = attributedText else { return }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: bounds.size)
        let textStorage = NSTextStorage(attributedString: text)
        
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let location = gesture.location(in: self)
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        for (range, url) in linkRanges {
            if NSLocationInRange(index, range) {
                delegate?.didTapOnLink(url)
                return
            }
        }
    }
}

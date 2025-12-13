//
//  LeftAlignedCollectionViewFlowLayout.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/12/2025.
//


import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Get the standard attributes calculated by the superclass
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        // Copy them because the attributes cache might be immutable
        guard let attributesCopy = attributes.map({ $0.copy() }) as? [UICollectionViewLayoutAttributes] else {
            return nil
        }

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0

        for layoutAttribute in attributesCopy {
            // Skip headers or footers, only align cells
            if layoutAttribute.representedElementCategory == .cell {
                
                // If the current cell starts on a new line (its Y is greater than the previous Max Y)
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }

                // Set the X position to the current left margin
                layoutAttribute.frame.origin.x = leftMargin

                // Update the left margin for the next cell (current X + width + spacing)
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                
                // Track the maximum Y to detect line breaks
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }

        return attributesCopy
    }
}
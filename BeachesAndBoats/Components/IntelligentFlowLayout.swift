//
//  IntelligentFlowLayout.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 14/09/2025.
//

import UIKit

class IntelligentFlowLayout: UICollectionViewFlowLayout {
    var itemSizes: [CGSize] = []
    var optimizedLayout: [(index: Int, frame: CGRect)] = []
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        calculateOptimizedLayout()
    }
    
    private func calculateOptimizedLayout() {
        guard let collectionView = collectionView else { return }
        
        optimizedLayout.removeAll()
        
        let containerWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let itemHeight: CGFloat = estimatedItemSize.height > 0 ? estimatedItemSize.height : 36
        
        var availableItems = Array(0..<itemSizes.count)
        var currentY: CGFloat = sectionInset.top
        
        while !availableItems.isEmpty {
            let rowItems = fillRowGreedily(
                availableItems: availableItems,
                containerWidth: containerWidth,
                itemHeight: itemHeight,
                currentY: currentY
            )
            
            // Add selected items to layout
            for (index, frame) in rowItems {
                optimizedLayout.append((index: index, frame: frame))
                availableItems.removeAll { $0 == index }
            }
            
            currentY += itemHeight + minimumLineSpacing
        }
    }
    
    private func fillRowGreedily(
        availableItems: [Int],
        containerWidth: CGFloat,
        itemHeight: CGFloat,
        currentY: CGFloat
    ) -> [(Int, CGRect)] {
        
        var selectedItems: [(Int, CGRect)] = []
        var remainingItems = availableItems
        var currentX: CGFloat = sectionInset.left
        var remainingWidth = containerWidth
        
        while !remainingItems.isEmpty {
            var bestFitIndex: Int?
            var bestFitWidth: CGFloat = 0
            
            for (arrayIndex, itemIndex) in remainingItems.enumerated() {
                let itemWidth = itemSizes[itemIndex].width
                if itemWidth <= remainingWidth && itemWidth > bestFitWidth {
                    bestFitIndex = arrayIndex
                    bestFitWidth = itemWidth
                }
            }
            
            guard let bestIndex = bestFitIndex else { break }
            
            let itemIndex = remainingItems[bestIndex]
            let itemWidth = bestFitWidth
            let frame = CGRect(x: currentX, y: currentY, width: itemWidth, height: itemHeight)
            
            selectedItems.append((itemIndex, frame))
            currentX += itemWidth + minimumInteritemSpacing
            remainingWidth -= (itemWidth + minimumInteritemSpacing)
            remainingItems.remove(at: bestIndex)
        }
        
        if selectedItems.isEmpty && !availableItems.isEmpty {
            let firstItem = availableItems[0]
            let itemWidth = min(itemSizes[firstItem].width, containerWidth)
            let frame = CGRect(x: sectionInset.left, y: currentY, width: itemWidth, height: itemHeight)
            selectedItems.append((firstItem, frame))
        }
        
        return selectedItems
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for (index, frame) in optimizedLayout {
            if frame.intersects(rect) {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
                attributes.frame = frame
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let layoutItem = optimizedLayout.first(where: { $0.index == indexPath.item }) {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = layoutItem.frame
            return attributes
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        guard !optimizedLayout.isEmpty else {
            return CGSize(width: collectionView?.bounds.width ?? 0, height: sectionInset.top + sectionInset.bottom)
        }
        
        let maxY = optimizedLayout.map { $0.frame.maxY }.max() ?? sectionInset.top
        let totalHeight = maxY + sectionInset.bottom
        
        print("IntelligentFlowLayout calculated height: \(totalHeight)")
        
        return CGSize(
            width: collectionView?.bounds.width ?? 0,
            height: totalHeight
        )
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return newBounds.width != collectionView.bounds.width
    }
}

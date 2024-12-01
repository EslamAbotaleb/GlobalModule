//
//  AlignFlowLayout.swift
//  CERQEL
//
//  Created by Eslam on 26/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit

public class CellAlignedFlowLayout: UICollectionViewFlowLayout {
    var isTable: Bool? = false
    var sectionCollapsed: Bool? = false
    private var cache: [UICollectionViewLayoutAttributes] = []

    public required init(itemSize: CGSize, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero, isTable: Bool? = nil, sectionCollapsed: Bool? = nil) {
        super.init()
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        sectionInsetReference = .fromSafeArea
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func prepare() {
        guard let collectionView = collectionView else { return }

        cache.removeAll()

        let numberOfSections = collectionView.numberOfSections
        debugPrint("Preparing layout for \(numberOfSections) sections")

        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            debugPrint("Section \(section): \(numberOfItems) items")

            let numberOfColumns = 2
            let itemWidth = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(numberOfColumns - 1) * 1) / CGFloat(numberOfColumns)

            var xOffsets: [CGFloat] = []
            for column in 0..<numberOfColumns {
                xOffsets.append(sectionInset.left + CGFloat(column) * (itemWidth + 0.4))
            }

            var yOffsets: [CGFloat] = Array(repeating: sectionInset.top, count: numberOfColumns)
            var columnHeights: [CGFloat] = Array(repeating: sectionInset.top, count: numberOfColumns)

            var currentRowHeight: CGFloat = 0
            var itemsInRow: [UICollectionViewLayoutAttributes] = []

            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let columnIndex = item % numberOfColumns
                let xOffset = xOffsets[columnIndex]

                // Calculate the height based on content
                let itemHeight: CGFloat = 2
                let yOffsetForItem = columnHeights[columnIndex]

                attributes.frame = CGRect(x: xOffset, y: yOffsetForItem, width: itemWidth, height: itemHeight)
                cache.append(attributes)
                debugPrint("minimumLineSpacing\(minimumLineSpacing)")
                // Update the column height after placing the item
                columnHeights[columnIndex] = yOffsetForItem + itemHeight + minimumLineSpacing

                // Track items to align rows
                itemsInRow.append(attributes)
                currentRowHeight = max(currentRowHeight, itemHeight)

                // When moving to next row, align top
                if (item + 1) % numberOfColumns == 0 || item == numberOfItems - 1 {
                    // Adjust yOffsets for all columns
                    let maxYOffset = itemsInRow.map { $0.frame.maxY }.max() ?? sectionInset.top
                    for i in 0..<numberOfColumns {
                        yOffsets[i] = maxYOffset + minimumLineSpacing
                    }
                    itemsInRow.removeAll()
                }
            }
        }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
         guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
         guard layoutAttributes.representedElementCategory == .cell else { return layoutAttributes }

         func layoutAttributesForRow() -> [UICollectionViewLayoutAttributes]? {
             guard let collectionView = collectionView else { return [layoutAttributes] }
             let contentWidth = collectionView.frame.size.width - sectionInset.left - sectionInset.right
             var rowFrame = layoutAttributes.frame
             rowFrame.origin.x = sectionInset.left
             rowFrame.size.width = contentWidth
             return super.layoutAttributesForElements(in: rowFrame)
         }

         let minYs = minimumYs(from: layoutAttributesForRow())
         guard let minY = minYs[layoutAttributes.indexPath] else { return layoutAttributes }
         layoutAttributes.frame = layoutAttributes.frame.offsetBy(dx: 0, dy: minY - layoutAttributes.frame.origin.y)
         return layoutAttributes
     }

     open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         let attributes = super.layoutAttributesForElements(in: rect)?
             .map { $0.copy() } as? [UICollectionViewLayoutAttributes]


         let minimumYs = minimumYs(from: attributes)
         attributes?.forEach {
             guard $0.representedElementCategory == .cell else { return }
             guard let minimumY = minimumYs[$0.indexPath] else { return }
             $0.frame = $0.frame.offsetBy(dx: 0, dy: minimumY - $0.frame.origin.y)
         }
         // Dictionary to store cells by their row (based on Y position)
         var rows = [CGFloat: [UICollectionViewLayoutAttributes]]()

         // Group attributes by rows (Y positions)
         attributes?.forEach {
             guard $0.representedElementCategory == .cell else { return }
             // Align cells to the top baseline using minimumY values
             if let minimumY = minimumYs[$0.indexPath] {
                 $0.frame = $0.frame.offsetBy(dx: 0, dy: minimumY - $0.frame.origin.y)
             }
             // Group cells by row (based on their Y position)
             let rowY = round($0.frame.origin.y)
             if rows[rowY] != nil {
                 rows[rowY]?.append($0)
             } else {
                 rows[rowY] = [$0]
             }
         }

         // Adjust horizontal alignment for each row
         rows.forEach { _, rowAttributes in
             if rowAttributes.count == 1 {
                 // Calculate the total width of items in the row (if needed for other logic)
                 let _ = rowAttributes.reduce(0) { $0 + $1.frame.width }
                 // Define the starting x position for left alignment (adjust for padding if necessary)
                 var currentX = CGFloat(0) // Adjust this value for padding if needed

                 // Update each item's frame to align to the left
                 rowAttributes.forEach { attribute in
                     // Ensure this is a cell, skip supplementary views (like headers/footers)
                     guard attribute.representedElementCategory == .cell else {
                         return // Skip adjusting headers/footers
                     }

                     // Apply the left-alignment logic
                     attribute.frame.origin.x = currentX
                     currentX += attribute.frame.width
                 }
             }
         }
         return attributes
     }
     /// Returns the minimum Y values based for each index path.
     private func minimumYs(from layoutAttributes: [UICollectionViewLayoutAttributes]?) -> [IndexPath: CGFloat] {
         layoutAttributes?
             .reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
                 guard $1.representedElementCategory == .cell else { return $0 }
                 return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
                     ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
                 }
             }
             .values.reduce(into: [IndexPath: CGFloat]()) { result, line in
                 line.1.forEach { result[$0.indexPath] = line.0 }
             } ?? [:]
     }
}


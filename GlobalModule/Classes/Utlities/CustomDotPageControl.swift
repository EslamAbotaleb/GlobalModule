//
//  CustomDotPageControl.swift
//  GlobalModule
//
//  Created by Eslam on 01/12/2024.
//

import UIKit

public class CustomDotPageControl: UIPageControl {

    // Optional closure for custom dot size calculation (default to equal spacing)
    public var calculateDotSize: ((_ totalPages: Int) -> CGFloat)?

    // Optional closure to customize the touch handling logic
    public var didSelectPage: ((_ pageIndex: Int) -> Void)?

    // Auto-scroll settings
    private var autoScrollTimer: Timer?
    private var isAutoScrolling = false
    public var autoScrollInterval: TimeInterval = 3.0 // Default auto-scroll interval in seconds
    public var isAutoScrollEnabled: Bool = false {
        didSet {
            if isAutoScrollEnabled {
                startAutoScrolling()
            } else {
                stopAutoScrolling()
            }
        }
    }

    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }

    private func initialize() {
        // Default customization (optional)
        self.calculateDotSize = { totalPages in
            return self.bounds.width / CGFloat(totalPages) // Equal spacing for dots
        }
    }

    // MARK: - Touch Handling
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let subview = self.subviews.first {
            let touchPoint = touch.location(in: subview)

            // Calculate the page index based on the touch location
            let pageIndex = calculatePageIndex(touchPoint: touchPoint, subview: subview)

            // Update the current page and notify listeners
            setCurrentPage(pageIndex)
        }
    }

    private func calculatePageIndex(touchPoint: CGPoint, subview: UIView) -> Int {
        let dotSize = calculateDotSize?(numberOfPages) ?? (subview.bounds.size.width / CGFloat(numberOfPages))
        return Int(touchPoint.x / dotSize)
    }

    private func setCurrentPage(_ pageIndex: Int) {
        guard pageIndex != currentPage else { return } // Prevent unnecessary updates
        currentPage = pageIndex
        didSelectPage?(pageIndex) // Call the custom handler if provided
    }

    // MARK: - Auto-Scroll Logic
    private func startAutoScrolling() {
        // If auto-scrolling is already in progress, do nothing
        guard !isAutoScrolling else { return }

        isAutoScrolling = true

        // Create and start a timer to auto-scroll
        autoScrollTimer = Timer.scheduledTimer(timeInterval: autoScrollInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }

    private func stopAutoScrolling() {
        // Stop the auto-scroll timer if it's active
        isAutoScrolling = false
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    @objc private func autoScroll() {
        // Prevent auto-scrolling if there are no pages
        guard numberOfPages > 0 else { return }

        // Calculate the next page index
        let nextPage = (currentPage + 1) % numberOfPages
        setCurrentPage(nextPage)
    }

    // MARK: - Public API
    public func resetCurrentPage() {
        setCurrentPage(0) // Reset to the first page
    }

    public func updateCurrentPage(to index: Int) {
        setCurrentPage(index) // Update to a specific page programmatically
    }
}

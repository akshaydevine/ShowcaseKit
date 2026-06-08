//
//  File.swift
//  ShowcaseKit
//
//  Created by priyal on 28/05/26.
//

import Foundation

public protocol ShowcaseControllerDelegate: AnyObject {
    func showcaseController(_ controller: ShowcaseController,
                            didMoveTo index: Int,
                            item: ShowcaseItem)
    func showcaseControllerDidDismiss(_ controller: ShowcaseController)
}

public class ShowcaseController {
    public weak var delegate: ShowcaseControllerDelegate?

    private var items:      [ShowcaseItem] = []
    private var registry:   [String: ShowcaseItem] = [:]
    private var frameMap:   [String: CGRect] = [:]
    private var completion: (() -> Void)?

    public private(set) var currentIndex: Int = 0

    public var totalSteps: Int { items.count }
    public var isFirst:    Bool { currentIndex == 0 }
    public var isLast:     Bool { currentIndex == totalSteps - 1 }

    public init() {}

    // MARK: - Registration

    public func registerItem(_ item: ShowcaseItem) {
        registry[item.id] = item
    }

    public func registerFrame(id: String, frame: CGRect) {
        frameMap[id] = frame
        if var item = registry[id] {
            item.frame   = frame
            registry[id] = item
        }
        // Also update the live items array so the overlay always
        // reads the latest frame regardless of when this is called
        if let idx = items.firstIndex(where: { $0.id == id }) {
            items[idx].frame = frame
        }
    }

    public func refreshHighlight(for id: String, frame: CGRect) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items[idx].frame = frame
        frameMap[id]     = frame
        // Only fire the delegate if this IS the current step —
        // and guard against re-entrant calls from the delegate itself
        guard currentIndex == idx else { return }
        delegate?.showcaseController(self, didMoveTo: idx, item: items[idx])
    }

    // MARK: - Start

    public func startShowcase(items: [ShowcaseItem], completion: (() -> Void)? = nil) {
        self.items      = items
        self.completion = completion
        currentIndex    = 0
        showCurrent()
    }

    public func startShowcase(orderedIDs: [String], completion: (() -> Void)? = nil) {
        self.completion = completion
        self.items = orderedIDs.compactMap { id -> ShowcaseItem? in
            guard var item = registry[id] else { return nil }
            if let f = frameMap[id] { item.frame = f }
            return item
        }
        currentIndex = 0
        showCurrent()
    }

    // MARK: - Navigation

    public func next() {
        if isLast { dismiss(); return }
        currentIndex += 1
        showCurrent()
    }

    public func previous() {
        guard !isFirst else { return }
        currentIndex -= 1
        showCurrent()
    }

    public func dismiss() {
        delegate?.showcaseControllerDidDismiss(self)
        completion?()
        completion = nil
    }

    // MARK: - Core: show with scroll-first, then layout-settle, then highlight

    private func showCurrent() {
        guard currentIndex < items.count else { return }
        let item = items[currentIndex]

        // 1. Fire onWillShow — caller scrolls the view into position here
        item.onWillShow?()

        // 2. Wait two run-loop ticks:
        //    tick 1 → UIKit processes the scroll + layout pass
        //    tick 2 → LayoutObserverView.layoutSubviews fires → syncFrame()
        //             updates items[currentIndex].frame via registerFrame
        //    tick 3 → frame is guaranteed stable, fire the delegate
        DispatchQueue.main.async { [weak self] in
            DispatchQueue.main.async { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    // Re-read the item — frame may have been updated by
                    // LayoutObserverView.syncFrame() during the ticks above
                    let latestItem = self.items[self.currentIndex]
                    self.delegate?.showcaseController(self,
                                                     didMoveTo: self.currentIndex,
                                                     item: latestItem)
                }
            }
        }
    }
}

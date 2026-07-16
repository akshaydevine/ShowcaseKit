//
//  File.swift
//  ShowcaseKit
//
//  Created by priyal on 28/05/26.
//

import Foundation
import UIKit

// MARK: - ShowcaseTarget

private class ShowcaseTarget {
    weak var view:       UIView?
    let item:            ShowcaseItem
    weak var controller: ShowcaseController?

    init(view: UIView, item: ShowcaseItem, controller: ShowcaseController) {
        self.view       = view
        self.item       = item
        self.controller = controller
    }

    func currentGlobalFrame() -> CGRect {
        guard let view   = view,
              let window = view.window else { return .zero }
        return view.convert(view.bounds, to: window)
    }

    func syncFrame() {
        let frame = currentGlobalFrame()
        guard frame != .zero else { return }
        controller?.registerFrame(id: item.id, frame: frame)
    }
}

// MARK: - Associated object keys

private var showcaseTargetKey:  UInt8 = 0
private var showcaseScrollKey:  UInt8 = 0

// MARK: - UIView extension

public extension UIView {

    /// Register this view as a showcase target.
    ///
    /// - Parameter scrollIntoView: Optional closure that scrolls this view
    ///   into the visible area. ShowcaseKit calls it automatically before
    ///   highlighting this step — no extra delegate code needed.
    func registerShowcase(
        id:                String,
        title:             String,
        description:       String,
        highlightInsets:   UIEdgeInsets        = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
        shape:             ShowcaseShape        = .rectangle(cornerRadius: 12),
        tooltipPosition:   TooltipPosition      = .auto,
        titleStyle:        ShowcaseTitleStyle   = .default,
        tooltipStyle:      ShowcaseTooltipStyle = .default,
        actionButtonTitle: String?              = nil,
        onTargetTap:       (() -> Void)?        = nil,
        scrollIntoView:    (() -> Void)?        = nil,   // ← NEW
        controller:        ShowcaseController
    ) {
        let item = ShowcaseItem(
            id:                id,
            frame:             .zero,
            highlightInsets:   highlightInsets,
            title:             title,
            description:       description,
            shape:             shape,
            tooltipPosition:   tooltipPosition,
            titleStyle:        titleStyle,
            tooltipStyle:      tooltipStyle,
            actionButtonTitle: actionButtonTitle,
            onTargetTap:       onTargetTap,
            onWillShow:        scrollIntoView    // ← wired here
        )

        let target = ShowcaseTarget(view: self, item: item, controller: controller)
        objc_setAssociatedObject(self, &showcaseTargetKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        controller.registerItem(item)

        DispatchQueue.main.async { target.syncFrame() }

        observeLayoutChanges(target: target)
    }

    // MARK: - Private

    private func observeLayoutChanges(target: ShowcaseTarget) {
        let observer = LayoutObserverView(target: target)
        observer.frame = .zero
        observer.isUserInteractionEnabled = false
        addSubview(observer)
    }
}

// MARK: - LayoutObserverView

private class LayoutObserverView: UIView {
    private let target: ShowcaseTarget

    init(target: ShowcaseTarget) {
        self.target = target
        super.init(frame: .zero)
        backgroundColor = .clear
        isHidden        = true
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        target.syncFrame()
    }
}

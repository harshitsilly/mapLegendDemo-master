//
//  DrawingObjectView.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/9/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
import SAPFiori


protocol FUIObject {
    var iconImages: [GlyphImage] { get set }
    var detailImage: UIImage? { get set }
    var headlineText: String? { get set }
    var subheadlineText: String? { get set }
    var footnoteText: String? { get set }
    var descriptionText: String? { get set }
    var statusText: String? { get set }
    var substatusText: String? { get set }
    var statusImage: UIImage? { get set }
    var substatusImage: UIImage? { get set }
}

protocol FUIObjectView {
    var headlineLabel: UILabel { get }
    var subheadlineLabel: UILabel { get }
    var footnoteLabel: UILabel { get }
    var descriptionLabel: UILabel { get }
    var statusLabel: UILabel { get }
    var substatusLabel: UILabel { get }
    var statusImageView: FUIImageView { get }
    var substatusImageView: FUIImageView { get }
    var detailImageView: FUIImageView { get }
}

protocol FUIObjectAdaptiveLayout {
    var splitPercent: CGFloat { get set }
    var isAdaptiveLayout: Bool { get set }
}

protocol FUITaggable {
    var tags: [String] { get set }
}

protocol FUIBackgroundSchemeSupporting {
    var backgroundColorScheme: FUIBackgroundColorScheme { get set }
}

@IBDesignable
class DrawingObjectView: UIView, FUIObjectView, FUIBackgroundSchemeSupporting, FUITaggable {

    var backgroundColorScheme: FUIBackgroundColorScheme = .lightBackground
    
    lazy private(set) var headlineLabel: UILabel = UILabel()
    lazy private(set) var subheadlineLabel: UILabel = UILabel()
    lazy private(set) var footnoteLabel: UILabel = UILabel()
    lazy private(set) var descriptionLabel: UILabel = UILabel()
    lazy private(set) var statusLabel: UILabel = UILabel()
    lazy private(set) var substatusLabel: UILabel = UILabel()
    lazy private(set) var statusImageView: FUIImageView = FUIImageView()
    lazy private(set) var substatusImageView: FUIImageView = FUIImageView()
    lazy private(set) var detailImageView: FUIImageView = FUIImageView()
    
    var tags: [String] = [String]() {
        didSet {
            needsRefreshMainAttributedString = true
        }
    }
    
    internal var tagRanges: [NSRange] = []

    var iconImages: [GlyphImage] = [GlyphImage]() {
        didSet {
            refreshIconImages()
        }
    }
    
    
    @IBInspectable
    var splitPercent: CGFloat = 0.4 {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsDisplay()
        }
    }
    @IBInspectable
    var preserveIconStackSpacing: Bool = false {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsDisplay()
        }
    }
    @IBInspectable
    var preserveDetailImageSpacing: Bool = false {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsDisplay()
        }
    }
    
    var iconsColumnWidth: CGFloat = 12 {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsDisplay()
        }
    }
    
    var detailImageViewSize: CGSize = CGSize(width: 45, height: 45) {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isAdaptiveLayout: Bool = true {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsDisplay()
        }
    }
    var isStatusForcedToCenterYAlignment: Bool = false {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsDisplay()
        }
    }
    
    let iconsContainer: NSTextContainer = NSTextContainer()
    let mainContainer: NSTextContainer = NSTextContainer()
    let descriptionContainer: NSTextContainer = NSTextContainer()
    let statusContainer: NSTextContainer = NSTextContainer()
    
    let iconsManager: NSLayoutManager = NSLayoutManager()
    let mainManager: TaggingLayoutManager = TaggingLayoutManager()
    let descriptionManager: NSLayoutManager = NSLayoutManager()
    let statusManager: NSLayoutManager = NSLayoutManager()
    
    let iconsStorage: NSTextStorage = NSTextStorage()
    let mainStorage: NSTextStorage = NSTextStorage()
    let descriptionStorage: NSTextStorage = NSTextStorage()
    let statusStorage: NSTextStorage = NSTextStorage()
    
    var headlineRange: NSRange?
    var subheadlineRange: NSRange?
    var footnoteRange: NSRange?
    var statusRange: NSRange?
    var substatusRange: NSRange?
    
    internal var horizontalSizeClass: UIUserInterfaceSizeClass = .unspecified
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        self.layoutMargins = .zero
        
        iconsManager.addTextContainer(iconsContainer)
        iconsStorage.addLayoutManager(iconsManager)
        
        mainManager.addTextContainer(mainContainer)
        mainStorage.addLayoutManager(mainManager)
        
        statusManager.addTextContainer(statusContainer)
        statusStorage.addLayoutManager(statusManager)
        
        descriptionManager.addTextContainer(descriptionContainer)
        descriptionStorage.addLayoutManager(descriptionManager)
        
        iconsContainer.lineFragmentPadding = 0
        mainContainer.lineFragmentPadding = 0
        descriptionContainer.lineFragmentPadding = 0
        statusContainer.lineFragmentPadding = 0
        
        iconsManager.usesFontLeading = false
        mainManager.usesFontLeading = false
        descriptionManager.usesFontLeading = false
        statusManager.usesFontLeading = false
        
        self.backgroundColor = .clear//UIColor.yellow.withAlphaComponent(0.2)
        self.contentMode = .redraw
        
        headlineLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        headlineLabel.textColor = UIColor.preferredFioriColor(forStyle: .primary1, background: backgroundColorScheme)
        headlineLabel.lineBreakMode = .byWordWrapping
        headlineLabel.numberOfLines = 0
        
        subheadlineLabel.font = UIFont.preferredFont(forTextStyle: .body)
        subheadlineLabel.textColor = UIColor.preferredFioriColor(forStyle: .primary2, background: backgroundColorScheme)
        subheadlineLabel.lineBreakMode = .byWordWrapping
        subheadlineLabel.numberOfLines = 0
        
        footnoteLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        footnoteLabel.textColor = UIColor.preferredFioriColor(forStyle: .primary3, background: backgroundColorScheme)
        footnoteLabel.lineBreakMode = .byWordWrapping
        footnoteLabel.numberOfLines = 0
        
        statusLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        statusLabel.textColor = UIColor.preferredFioriColor(forStyle: .primary3, background: backgroundColorScheme)
        statusLabel.textAlignment = .right
        statusLabel.lineBreakMode = .byTruncatingTail
        
        substatusLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        substatusLabel.textAlignment = .right
        substatusLabel.textColor = UIColor.preferredFioriColor(forStyle: .primary3, background: backgroundColorScheme)
        substatusLabel.lineBreakMode = .byTruncatingTail
        
        
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.textColor = UIColor.preferredFioriColor(forStyle: .primary3, background: backgroundColorScheme)
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        iconImages.removeAll()
        detailImage = nil
        headlineText = nil
        subheadlineText = nil
        footnoteText = nil
        descriptionText = nil
        statusText = nil
        statusImage = nil
        substatusText = nil
        substatusImage = nil
        
        
        self.addSubview(detailImageView)
        detailImageView.isHidden = true
        detailImageView.contentMode = .scaleAspectFill
        detailImageView.image = nil
        detailImageView.clipsToBounds = true
        let _  = self.detailImageView.observe(\.image) { observed, change in
            observed.isHidden = change.newValue == nil
            self.setNeedsUpdateConstraints()
        }

        isAdaptiveLayout = true
        preserveIconStackSpacing = false
        preserveDetailImageSpacing = false
        iconsColumnWidth = 16
        detailImageViewSize = CGSize(width: Dimension.detailImageWidth.value, height: Dimension.detailImageHeight.value)
        
    }

    private var iconsSize: CGSize = .zero
    private var statusSize: CGSize = .zero
    private var descriptionSize: CGSize = .zero
    
    private var statusOrigin: CGPoint = .zero
    private var mainOrigin: CGPoint = .zero
    private var detailOrigin: CGPoint = .zero
    private var iconsOrigin: CGPoint = .zero
    private var descriptionOrigin: CGPoint = .zero
    
    // calculated once
    internal var iconsXAndPaddedWidth: (x: CGFloat, paddedWidth: CGFloat) = (x: 0, paddedWidth: 0)
    internal var detailXAndPaddedWidth: (x: CGFloat, paddedWidth: CGFloat) = (x: 0, paddedWidth: 0)
    internal var mainXAndWidth: (originX: CGFloat, width: CGFloat) = (originX: 0, width: 0)
    internal var statusXAndSize: (originX: CGFloat, size: CGSize) = (originX: 0, size: .zero)
    internal var descriptionXAndWidth: (originX: CGFloat, width: CGFloat) = (originX: 0, width: 0)
    
    private var mainRect: CGRect = .zero

    public var calculateLayoutsCount: Int = 0
    public var isMultiline: Bool {
        return !isSingleLine
    }
    private var isSingleLine: Bool = true
    
    internal var needsRefreshAttributedString: Bool = false
    internal var needsRefreshMainAttributedString: Bool = false
    
    
    internal var isTransitioning: Bool = false
    internal var transitioningCachedMaxHeight: CGFloat = 0
    
    func calculateLayouts(_ targetSize: CGSize) {

        calculateLayoutsCount += 1
        print("ObjectView: calculate Layouts count: \(calculateLayoutsCount) forTargetSize: \(targetSize)")

        horizontalSizeClass = isRegularHorizontalSizeClass(forWidth: targetSize.width) ? .regular : .compact
        
        
        if needsRefreshAttributedString {
            refreshAttributedString()
        }
        
        if needsRefreshMainAttributedString {
            refreshMainAttributedString()
        }
        
        calculateLayoutsCount += 1
        // DO Tasks common to all
        // inexpensive, except for statusXAndSize
        iconsXAndPaddedWidth = iconsOriginXAndPaddedWidth()
        detailXAndPaddedWidth = detailOriginXAndPaddedWidth()
        mainXAndWidth = mainOriginXAndWidth(targetSize)
        statusXAndSize = statusOriginXAndSize(targetSize)
        descriptionXAndWidth = descriptionOriginXAndWidth(targetSize)
        
        // expensive, so do only once
        mainRect = (self.horizontalSizeClass == .compact || !isAdaptiveLayout) ? applyMainExclusionPath() : applyMainSplit()
        
        // determine whether single line or multi-line, before calculating sizes of icons, status, description
        isSingleLine = !mainManager.isMultiline
        if isSingleLine {
            iconsContainer.maximumNumberOfLines = detailImageView.image != nil ? 2 : 1
            statusContainer.maximumNumberOfLines = 1
            descriptionContainer.maximumNumberOfLines = 1
            iconsContainer.lineBreakMode = .byClipping
            statusContainer.lineBreakMode = .byClipping
            statusXAndSize = (originX: statusXAndSize.originX, size: singleLineStatusSize(statusXAndSize.size))
            descriptionContainer.lineBreakMode = .byClipping
        } else {
            iconsContainer.maximumNumberOfLines = 0
            statusContainer.maximumNumberOfLines = 0
            descriptionContainer.maximumNumberOfLines = 0
            iconsContainer.lineBreakMode = .byWordWrapping
            statusContainer.lineBreakMode = .byWordWrapping
            descriptionContainer.lineBreakMode = .byWordWrapping
        }
        
        // calculate the sizes of the containers
        // *expensive*, so only calculate if needed
        iconsContainer.size = CGSize(width: iconsColumnWidth, height: 3000)
        if iconsStorage.length > 0 {
            iconsSize = iconsManager.boundingRect(forGlyphRange: iconsManager.fullGlyphRange, in: iconsContainer).size
        } else {
            iconsSize = .zero
        }
        
        // already calculated
        statusSize = statusXAndSize.size
        statusContainer.size = statusSize
        
        if descriptionXAndWidth.width > 0 {
            descriptionContainer.size = CGSize(width: descriptionXAndWidth.width, height: 3000)
            descriptionSize = descriptionManager.boundingRect(forGlyphRange: descriptionManager.fullGlyphRange, in: descriptionContainer).size
        } else {
            descriptionSize = .zero
        }
        
        
        if isSingleLine {
            maxHeight = max(detailImageView.image != nil ? detailImageViewSize.height : 0, mainRect.height, descriptionSize.height)
            let midY = maxHeight / 2
            
            iconsOrigin.y = midY - iconsSize.midY
            detailOrigin.y = midY - detailImageViewSize.midY
            mainOrigin.y = midY - mainRect.size.midY
            statusOrigin.y = midY - statusSize.midY
            descriptionOrigin.y = descriptionSize.midY
        } else {
            let mainFirstBaselineHeight = mainManager.firstBaselineHeight
            
            mainOrigin.y = mainOriginY()
            
            if descriptionSize.width > 0 {
                descriptionOrigin.y = mainOrigin.y + mainFirstBaselineHeight - descriptionManager.firstBaselineHeight
            }
            
            var mainFirstCapHeight: CGFloat? = nil
            if detailImageView.image != nil {
                mainFirstCapHeight = mainManager.firstCapHeight
                detailOrigin.y = mainFirstCapHeight!
            }
            
            if iconsAreBaselineAligned() {
                iconsOrigin.y = mainOrigin.y + mainFirstBaselineHeight - iconsManager.firstBaselineHeight
            } else {
                iconsOrigin.y = mainFirstCapHeight ?? mainManager.firstCapHeight
            }
            
            let descriptionAdjustedHeight = descriptionOrigin.y + descriptionSize.height
            let detailImageViewAdjustedHeight = detailOrigin.y + detailImageViewSize.height
            maxHeight = max(detailImageViewAdjustedHeight, mainRect.height + mainOrigin.y, descriptionAdjustedHeight)
            let midY = maxHeight / 2
            
            if statusSize.width > 0 {
                if isStatusForcedToCenterYAlignment {
                    statusOrigin.y = midY - statusXAndSize.size.midY
                } else {
                    statusOrigin.y = mainOrigin.y + mainFirstBaselineHeight - statusManager.firstBaselineHeight
                }
            }
        }
        
        iconsOrigin.x = iconsXAndPaddedWidth.x
        detailOrigin.x = detailXAndPaddedWidth.x
        mainOrigin.x = mainXAndWidth.originX
        statusOrigin.x = statusXAndSize.originX
        descriptionOrigin.x = descriptionXAndWidth.originX
        
        if detailImageView.image != nil {
            detailImageView.frame = CGRect(origin: detailOrigin, size: detailImageViewSize)
        }
    }

    internal var maxHeight: CGFloat = 22 // some dummy non-zero default
    
    override func draw(_ rect: CGRect) {
        
        iconsManager.drawBackground(forGlyphRange: iconsManager.fullGlyphRange, at: iconsOrigin)
        iconsManager.drawGlyphs(forGlyphRange: iconsManager.fullGlyphRange, at: iconsOrigin)
        
        mainManager.drawBackground(forGlyphRange: mainManager.fullGlyphRange, at: mainOrigin)
        mainManager.drawGlyphs(forGlyphRange: mainManager.fullGlyphRange, at: mainOrigin)
        
        statusManager.drawBackground(forGlyphRange: statusManager.fullGlyphRange, at: statusOrigin)
        statusManager.drawGlyphs(forGlyphRange: statusManager.fullGlyphRange, at: statusOrigin)
        
        if self.horizontalSizeClass == .regular && isAdaptiveLayout {
            
            descriptionManager.drawBackground(forGlyphRange: descriptionManager.fullGlyphRange, at: descriptionOrigin)
            descriptionManager.drawGlyphs(forGlyphRange: descriptionManager.fullGlyphRange, at: descriptionOrigin)
            
        }
        
        detailImageView.isHidden = detailImageView.image == nil
    }

    
 enum Dimension: String {
        
        case zero
        case iconsWidth
        case iconsTrailingPad
        case detailImageWidth
        case detailImageHeight
        case detailImageTrailingPad
        case mainTextToSplitTrailingPad
        case descriptionTextToSplitLeadingPad
        case descriptionTextToStatusTrailingPad
        case statusViewLeadingPad
        case iconsParagraphSpacing
        case labelsParagraphSpacing
        case statusParagraphSpacing
        case statusViewBottomPad
        
        var value: CGFloat {
            switch self {
            case .zero:
                return 0
            case .iconsWidth:
                return 12
            case .iconsTrailingPad, .detailImageTrailingPad, .statusViewLeadingPad:
                return 12
            case .mainTextToSplitTrailingPad:
                return 8
            case .descriptionTextToSplitLeadingPad:
                return 16
            case .descriptionTextToStatusTrailingPad:
                return 24
            case .detailImageWidth, .detailImageHeight:
                return 45
            case .statusViewBottomPad:
                return 4
            case .iconsParagraphSpacing, .labelsParagraphSpacing, .statusParagraphSpacing:
                return 3
            }
        }
    }

}








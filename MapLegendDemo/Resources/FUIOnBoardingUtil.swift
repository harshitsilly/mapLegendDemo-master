//
//  FUIOnboardingUtil.swift
//  SAPFiori
//
//  Copyright © 2016 - 2017 SAP SE or an SAP affiliate company. All rights reserved.
//
//  No part of this publication may be reproduced or transmitted in any form or for any purpose
//  without the express permission of SAP SE. The information contained herein may be changed
//  without prior notice.
//

import Foundation
import UIKit

//This is an internal class
/// :nodoc:
class FUIOnboardingUtil {
    enum SupportedType: Int {
        //height == 568, iPhoneSE, iPhone5, iPhone5s
        case iphoneSE = 1
        
        case iphoneSELandscape

        //height == 667, iPhone6, iPhone6s, iPhone7
        case iphone

        case iphoneLandscape
        
        //height == 736, iPhone6 Plus, iPhone6s Plus, iPhone7 Plus
        case iphonePlus
        
        case iphonePlusLandscape

        //any ipad in portrait mode that is not ipadProPortrait
        case ipadPortrait

        //any ipad in landscape mode that is not ipadProLandscape
        case ipadLandscape

        //height is >= 1366, ipadPro 12.9
        case ipadPro12_9Portrait

        //height is >= 1024.0, ipadPro 12.9
        case ipadPro12_9Landscape
    }

    static let portraitHeightSE: CGFloat = 568
    static let landscapeHeightSE: CGFloat = 320
    static let portraitHeightiPhone: CGFloat = 667
    static let landscapeHeightiPhone: CGFloat = 375
    static let portraitHeightiPhonePlus: CGFloat = 736
    static let landscapeHeightiPhonePlus: CGFloat = 414
    static let portraitHeightiPad: CGFloat = 1024
    static let landscapeHeightiPad: CGFloat = 768
    static let portraitHeightiPad12_9 = CGFloat(1366)
    static let landscapeHeightiPad12_9 = CGFloat(1024)

    static var isCurrentOrientationPortrait : Bool = false

    static var currentSupportedType: SupportedType {
        get {
            //iphone
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                if isCurrentOrientationPortrait {
                    
                    switch(UIScreen.main.bounds.height) {
                        case 568.0:
                            return SupportedType.iphoneSE
                        case 667.0:
                            return SupportedType.iphone
                        case 736.0:
                            return SupportedType.iphonePlus
                        default:
                            print("DANGER SHOULD NOT GET HERE")
                            return SupportedType.iphoneSE
                    }
                }
                return UIScreen.main.bounds.height <= portraitHeightSE ? SupportedType.iphoneSELandscape : SupportedType.iphoneLandscape
            }
            //ipad
            if isCurrentOrientationPortrait {
                return UIScreen.main.bounds.height >= portraitHeightiPad12_9 ? SupportedType.ipadPro12_9Portrait : SupportedType.ipadPortrait
            }
            return UIScreen.main.bounds.height >= landscapeHeightiPad12_9 ? SupportedType.ipadPro12_9Landscape : SupportedType.ipadLandscape
            
        }
    }
}


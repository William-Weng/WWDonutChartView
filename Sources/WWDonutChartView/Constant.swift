//
//  Constant.swift
//  WWDonutChartView
//
//  Created by William-Weng on 2024/6/20.
//  Copyright © 2024年 William-Weng. All rights reserved.
//

import UIKit

// MARK: Constant
final class Constant: NSObject {}

// MARK: typealias
extension Constant {
    typealias BasicAnimationInformation = (animation: CABasicAnimation, keyPath: Constant.AnimationKeyPath) // Basic動畫資訊
}

// MARK: enum
extension Constant {
    
    /// [動畫路徑 (KeyPath)](https://stackoverflow.com/questions/44230796/what-is-the-full-keypath-list-for-cabasicanimation)
    enum AnimationKeyPath: String {
        case strokeEnd = "strokeEnd"
    }
}

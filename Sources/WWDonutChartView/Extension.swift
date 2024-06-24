//
//  Extension.swift
//  WWDonutChartView
//
//  Created by iOS on 2024/6/20.
//  Copyright © 2024 IIT-翁禹斌(William.Weng). All rights reserved.
//

import UIKit
import CoreGraphics
import AVFoundation

// MARK: CGFloat (class function)
extension CGFloat {
    
    /// 180° => π
    func _radian() -> CGFloat { return (self / 180.0) * .pi }
    
    /// π => 180°
    func _angle() -> CGFloat { return self * (180.0 / .pi) }
}

// MARK: Collection (function)
extension Collection where Self.Element: CALayer {
    
    /// 將所有CALayer移除
    func _removeFromSuperlayer() {
        self.forEach { $0.removeFromSuperlayer() }
    }
}

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: UIView (class function)
extension UIView {
    
    /// 找出適合的半徑 (寬或高的一半)
    /// - Returns: CGFloat
    /// - Parameters:
    ///   - lineWidth: 線寬
    func _fitRadius(lineWidth: CGFloat = 0.0) -> CGFloat {
        let fitDiameter = (frame.height > frame.width) ? frame.width : frame.height
        return (fitDiameter - lineWidth) * 0.5
    }
}

// MARK: - CGPoint (Operator Overloading)
extension CGPoint {
    
    /// CGPoint的加法
    /// - Parameters:
    ///   - lhs: CGPoint
    ///   - rhs: CGPoint
    /// - Returns: CGPoint
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    /// CGPoint的減法
    /// - Parameters:
    ///   - lhs: CGPoint
    ///   - rhs: CGPoint
    /// - Returns: CGPoint
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

// MARK: - CGPoint (function)
extension CGPoint {
    
    /// [半徑 - 圓點 (0, 0)](https://zh.wikipedia.org/wiki/勾股定理)
    func _radius() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
}

// MARK: CGPath (class function)
extension CGPath {
    
    /// 建立圓形(弧)路徑
    /// - View的半徑
    /// - Parameters:
    ///   - center: 中點
    ///   - radius: 半徑
    ///   - startAngle: 開始的角度
    ///   - endAngle: 結束的角度
    ///   - clockwise: 順時針 / 逆時針
    /// - Returns: CGMutablePath
    static func _buildCirclePath(center: CGPoint, radius: CGFloat, from startAngle: CGFloat = .zero, to endAngle: CGFloat = .pi, clockwise: Bool = false) -> CGMutablePath {

        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)

        return path
    }
}

// MARK: CALayer (static function)
extension CALayer {
    
    /// Layer產生器
    /// - 含路徑 + 相關設定
    /// - Parameters:
    ///   - path: 繪圖的路徑
    ///   - strokeColor: 線的顏色
    ///   - fillColor: 背景色
    ///   - lineWidth: 線寬
    ///   - lineCap: 設定兩邊端點的樣子
    /// - Returns: CAShapeLayer
    static func _shape(with path: CGPath?, strokeColor: UIColor? = .black, fillColor: UIColor? = nil, lineWidth: CGFloat = 10, lineCap: CAShapeLayerLineCap = .butt) -> CAShapeLayer {
        
        let layer = CAShapeLayer()

        layer.path = path
        layer.lineWidth = lineWidth
        layer.strokeColor = strokeColor?.cgColor
        layer.fillColor = fillColor?.cgColor
        layer.lineCap = lineCap

        return layer
    }
    
    /// [設置陰影](https://www.jianshu.com/p/2c90d6a637f7)
    /// - Parameters:
    ///   - color: 陰影顏色
    ///   - backgroundColor: 陰影背景色
    ///   - offset: 陰影位移
    ///   - opacity: 陰影不透明度
    ///   - radius: 陰影半徑
    ///   - cornerRadius: 圓角半徑
    func _shadow(color: UIColor, backgroundColor: UIColor, offset: CGSize, opacity: Float, radius: CGFloat, cornerRadius: CGFloat) {
        
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowOpacity = opacity
        shadowRadius = radius
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor.cgColor
    }
}

// MARK: CAAnimation (static function)
extension CAAnimation {
    
    /// [Layer動畫產生器 (CABasicAnimation)](https://jjeremy-xue.medium.com/swift-說說-cabasicanimation-9be31ee3eae0)
    /// - Parameters:
    ///   - keyPath: [要產生的動畫key值](https://blog.csdn.net/iosevanhuang/article/details/14488239)
    ///   - delegate: [CAAnimationDelegate?](https://juejin.cn/post/6936070813648945165)
    ///   - fromValue: 開始的值
    ///   - toValue: 結束的值
    ///   - duration: 動畫時間
    ///   - repeatCount: 播放次數
    ///   - fillMode: [CAMediaTimingFillMode](https://juejin.cn/post/6991371790245183496)
    ///   - isRemovedOnCompletion: Bool
    /// - Returns: Constant.CAAnimationInformation
    static func _basicAnimation(keyPath: Constant.AnimationKeyPath = .strokeEnd, delegate: CAAnimationDelegate? = nil, fromValue: Any?, toValue: Any?, duration: CFTimeInterval = 5.0, repeatCount: Float = 1.0, fillMode: CAMediaTimingFillMode = .forwards, isRemovedOnCompletion: Bool = false) -> Constant.BasicAnimationInformation {
        
        let animation = CABasicAnimation(keyPath: keyPath.rawValue)
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.fillMode = fillMode
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        animation.delegate = delegate
        
        return (animation, keyPath)
    }
}



//
//  Extension.swift
//  CAShapeLayer_Animation
//
//  Created by iOS on 2024/6/20.
//  Copyright © 2024 IIT-翁禹斌(William.Weng). All rights reserved.
//

import UIKit
import CoreGraphics
import AVFoundation

// MARK: - CGFloat (class function)
extension CGFloat {
    
    /// 180° => π
    func _radian() -> CGFloat { return (self / 180.0) * .pi }
    
    /// π => 180°
    func _angle() -> CGFloat { return self * (180.0 / .pi) }
}

// MARK: - Collection (function)
extension Collection where Self.Element: CALayer {
    
    /// 將所有CALayer移除
    func _removeFromSuperlayer() {
        self.forEach { $0.removeFromSuperlayer() }
    }
}

// MARK: - UIView (class function)
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

// MARK: - CGPath (class function)
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

// MARK: - CALayer (static function)
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
}

// MARK: - CAAnimation (static function)
extension CAAnimation {
    
    /// [Layer動畫產生器 (CABasicAnimation)](https://jjeremy-xue.medium.com/swift-說說-cabasicanimation-9be31ee3eae0)
    /// - Parameters:
    ///   - keyPath: [要產生的動畫key值](https://blog.csdn.net/iosevanhuang/article/details/14488239)
    ///   - fromValue: 開始的值
    ///   - toValue: 結束的值
    ///   - duration: 動畫時間
    ///   - repeatCount: 播放次數
    ///   - fillMode: [CAMediaTimingFillMode](https://juejin.cn/post/6991371790245183496)
    /// - Returns: Constant.CAAnimationInformation
    static func _basicAnimation(keyPath: Constant.AnimationKeyPath = .strokeEnd, fromValue: Any?, toValue: Any?, duration: CFTimeInterval = 5.0, repeatCount: Float = 1.0, fillMode: CAMediaTimingFillMode = .forwards, isRemovedOnCompletion: Bool = false) -> Constant.BasicAnimationInformation {
        
        let animation = CABasicAnimation(keyPath: keyPath.rawValue)
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.fillMode = fillMode
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        
        return (animation, keyPath)
    }
}

// MARK: - Constant
final class Constant: NSObject {}

// MARK: - typealias
extension Constant {
    typealias BasicAnimationInformation = (animation: CABasicAnimation, keyPath: Constant.AnimationKeyPath)                         // Basic動畫資訊
}

extension Constant {
    
    /// [動畫路徑 (KeyPath)](https://stackoverflow.com/questions/44230796/what-is-the-full-keypath-list-for-cabasicanimation)
    enum AnimationKeyPath: String {
        case strokeEnd = "strokeEnd"
    }
}

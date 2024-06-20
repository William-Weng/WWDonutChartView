//
//  WWDonutChartView.swift
//  WWDonutChartView
//
//  Created by William-Weng on 2024/6/20.
//  Copyright © 2024年 William-Weng. All rights reserved.
//

import UIKit
import CoreGraphics
import AVFoundation

// MARK: - WWDonutChartViewDelegate
public protocol WWDonutChartViewDelegate: AnyObject {
    
    func informations(in donutChartView: WWDonutChartView) -> [WWDonutChartView.LineInformation]    // 取得資料相關資訊
}

// MARK: - WWDonutChartView
@IBDesignable 
open class WWDonutChartView: UIView {
    
    public typealias LineInformation = (strokeColor: UIColor, percent: CGFloat)    // (線的顏色, 百分比)
    
    @IBOutlet var contentView: UIView!
    
    @IBInspectable var lineWidth: CGFloat = 10.0
    @IBInspectable var baseLineColor: UIColor = .black
    
    public weak var delegate: WWDonutChartViewDelegate?
    
    private let rootLayer = CALayer()
    private let startAngle: CGFloat = -90
    private let endAngle: CGFloat = 270
    private let pathAnimationKey = "strokeEndAnimation"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
    
    public override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        layerSetting(with: rect)
        shapeLayerDrawing(lineCap: .butt)
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

// MARK: 公開函式
public extension WWDonutChartView {
    
    /// 設定線寬 / 底線的顏色
    /// - Parameters:
    ///   - lineWidth: CGFloat
    ///   - baseLineColor: UIColor
    func setting(lineWidth: CGFloat, baseLineColor: UIColor) {
        
        self.lineWidth = lineWidth
        self.baseLineColor = baseLineColor
    }
    
    /// 繪製動畫線條
    /// - Parameters:
    ///   - lineCap: 線頭樣式
    ///   - duration: 動畫時間
    func drawing(lineCap: CAShapeLayerLineCap = .round, duration: Double = 1.0) {
        clean()
        animateCAShapeLayerDrawing(lineCap: lineCap, duration: duration)
    }
    
    /// 清除線段
    func clean() {
        
        rootLayer.removeAllAnimations()
        rootLayer.sublayers?._removeFromSuperlayer()
        
        shapeLayerDrawing(lineCap: .butt)
    }
}

// MARK: 主功能
private extension WWDonutChartView {
    
    /// 載入XIB的一些基本設定
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let xibName = String(describing: WWDonutChartView.self)

        bundle.loadNibNamed(xibName, owner: self, options: nil)
        contentView.frame = self.bounds
        
        addSubview(contentView)
    }
    
    /// 基本設定 (外框設定)
    /// - Parameter rect: CGRect
    func layerSetting(with rect: CGRect) {
                
        rootLayer.frame = rect
        rootLayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        layer.addSublayer(rootLayer)
    }
    
    /// 畫圓
    /// - Parameter lineCap: CAShapeLayerLineCap
    func shapeLayerDrawing(lineCap: CAShapeLayerLineCap) {
        
        let layer = baseShapeLayer(from: startAngle, to: endAngle, strokeColor: baseLineColor, lineCap: lineCap)
        rootLayer.addSublayer(layer)
    }
    
    /// 畫圓弧 + 動畫
    /// - Parameters:
    ///   - lineCap: CAShapeLayerLineCap
    ///   - duration: Double
    func animateCAShapeLayerDrawing(lineCap: CAShapeLayerLineCap, duration: Double) {
        
        guard let infos = delegate?.informations(in: self) else { return }
        
        var totalPercent: CGFloat = 0
        
        let layers = infos.map { info in
            
            let layer = baseShapeLayer(from: startAngle, to: endAngle, strokeColor: info.strokeColor, lineCap: lineCap)
            
            totalPercent += info.percent
            layer.add(pathAnimation(percent: totalPercent, duration: duration), forKey: pathAnimationKey)
            
            return layer
        }
        
        layers.reversed().forEach { rootLayer.addSublayer($0) }
    }
}

// MARK: 小工具
private extension WWDonutChartView {
    
    /// 基本的圓形路徑Layer
    /// - Parameters:
    ///   - startAngle: 開始角度
    ///   - endAngle: 結束角度
    ///   - strokeColor: 線的顏色
    ///   - lineCap: 線頭樣式
    /// - Returns: CAShapeLayer
    func baseShapeLayer(from startAngle: CGFloat = .zero, to endAngle: CGFloat, strokeColor: UIColor, lineCap: CAShapeLayerLineCap) -> CAShapeLayer {
        
        let path = CGPath._buildCirclePath(center: contentView.center, radius: self._fitRadius(lineWidth: lineWidth), from: startAngle._radian(), to: endAngle._radian(), clockwise: false)
        let layer = CALayer._shape(with: path, strokeColor: strokeColor, fillColor: nil, lineWidth: lineWidth, lineCap: lineCap)
        
        return layer
    }
    
    /// 基本的圓弧動畫
    /// - Parameters:
    ///   - percent: 百分比
    ///   - duration: 動畫時間
    /// - Returns: CABasicAnimation
    func pathAnimation(percent: CGFloat, duration: Double) -> CABasicAnimation {
        let result = CAAnimation._basicAnimation(keyPath: .strokeEnd, fromValue: 0.0, toValue: percent, duration: duration, repeatCount: 1, fillMode: .forwards, isRemovedOnCompletion: false)
        return result.animation
    }
}


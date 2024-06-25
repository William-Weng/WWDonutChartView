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
    
    func duration(in donutChartView: WWDonutChartView) -> Double                                                                // 動畫的總時間 (360°)
    func informations(in donutChartView: WWDonutChartView) -> [WWDonutChartView.LineInformation]                                // 取得資料相關資訊
    func donutChartView(_ donutChartView: WWDonutChartView, didSelectedIndex index: Int?)                                       // 點到哪一個圓環的Index
    func donutChartView(_ donutChartView: WWDonutChartView, animation: CAAnimation, didStop isStop: Bool, isFinished: Bool)     // 動畫開始 / 停止 / 全部完成
}

// MARK: - WWDonutChartView
@IBDesignable 
open class WWDonutChartView: UIView {
    
    public typealias LineInformation = (title: String, strokeColor: UIColor, percent: CGFloat)      // (標題, 線的顏色, 百分比)
    
    typealias ChartAngle = (start: CGFloat, end: CGFloat)                                           // (起始角度, 結束角度)
    
    public enum AnimtionType {
        case queue                                                                                  // 照順序一個一個出現
        case same                                                                                   // 同時一起出現
    }
    
    @IBOutlet var contentView: UIView!
    
    @IBInspectable var lineWidth: CGFloat = 10.0
    @IBInspectable var touchGap: CGFloat = 0
    @IBInspectable var baseLineColor: UIColor = .black
    
    public weak var delegate: WWDonutChartViewDelegate?
    
    private let rootLayer = CALayer()
    private let circleAngle: ChartAngle = (start: -90, end: 270)
    private let pathAnimationKey = "strokeEndAnimation"
    private let shadowView = UIView(frame: .zero)

    private var isFinished = false
    private var animaitonStopFlags: [Bool] = []
    private var lineCap: CAShapeLayerLineCap = .butt
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
}

// MARK: override
public extension WWDonutChartView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBeganAction(touches, with: event)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layerSetting(with: rect)
        shapeLayerDrawing(lineCap: .butt)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

// MARK: CAAnimationDelegate
extension WWDonutChartView: CAAnimationDelegate {}

// MARK: CAAnimationDelegate
public extension WWDonutChartView {
    
    func animationDidStart(_ anim: CAAnimation) {
        delegate?.donutChartView(self, animation: anim, didStop: false, isFinished: false)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animaitonStopFlags.append(flag)
        isFinished = checkAnimationStop(flags: animaitonStopFlags)
        delegate?.donutChartView(self, animation: anim, didStop: flag, isFinished: isFinished)
    }
}

// MARK: 公開函式
public extension WWDonutChartView {
    
    /// 設定線寬 / 底線的顏色
    /// - Parameters:
    ///   - lineWidth: CGFloat
    ///   - baseLineColor: UIColor
    ///   - touchGap: 園環範圍內縮的距離
    func setting(lineWidth: CGFloat, baseLineColor: UIColor, touchGap: CGFloat) {
        
        self.lineWidth = lineWidth
        self.baseLineColor = baseLineColor
        self.touchGap = touchGap
    }
    
    /// 繪製動畫線條
    /// - Parameters:
    ///   - lineCap: 線頭樣式
    ///   - animtionType: 動畫樣式
    func drawing(lineCap: CAShapeLayerLineCap = .butt, animtionType: AnimtionType = .queue) {
        clean()
        animateCAShapeLayerDrawing(lineCap: lineCap, animtionType: animtionType)
        delegate?.donutChartView(self, didSelectedIndex: nil)
    }
    
    /// 清除線段 / 應該清的
    func clean() {
        
        isFinished = false
        animaitonStopFlags = []
        
        rootLayer.removeAllAnimations()
        rootLayer.sublayers?._removeFromSuperlayer()
        
        shadowView.removeFromSuperview()
        shadowView.layer.sublayers?._removeFromSuperlayer()
        
        shapeLayerDrawing(lineCap: lineCap)
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
        
        let layer = baseShapeLayer(from: circleAngle.start, to: circleAngle.end, strokeColor: baseLineColor, lineCap: lineCap)
        rootLayer.addSublayer(layer)
    }
    
    /// 畫圓弧動畫 (同時畫)
    /// - Parameters:
    ///   - lineCap: CAShapeLayerLineCap
    ///   - animtionType: AnimtionType
    func animateCAShapeLayerDrawing(lineCap: CAShapeLayerLineCap, animtionType: AnimtionType) {
        
        guard let infos = delegate?.informations(in: self),
              let totalDuration = delegate?.duration(in: self)
        else {
            return
        }
        
        var totalPercent: CGFloat = 0
        
        let layers = infos.map { info in
            
            let layer = baseShapeLayer(from: circleAngle.start, to: circleAngle.end, strokeColor: info.strokeColor, lineCap: lineCap)
            var duration = 0.0
            
            totalPercent += info.percent
            
            switch animtionType {
            case .same: duration = totalDuration
            case .queue: duration = totalDuration * totalPercent
            }
            
            layer.add(pathAnimation(percent: totalPercent, duration: duration), forKey: pathAnimationKey)
            
            return layer
        }
        
        layers.reversed().forEach { rootLayer.addSublayer($0) }
        
        self.lineCap = lineCap
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
    ///   - lineWidthOffset: 線寬加粗
    /// - Returns: CAShapeLayer
    func baseShapeLayer(from startAngle: CGFloat = .zero, to endAngle: CGFloat, strokeColor: UIColor, lineCap: CAShapeLayerLineCap, lineWidthOffset: CGFloat = 0) -> CAShapeLayer {
        
        let path = CGPath._buildCirclePath(center: contentView.center, radius: self._fitRadius(lineWidth: lineWidth), from: startAngle._radian(), to: endAngle._radian(), clockwise: false)
        let layer = CALayer._shape(with: path, strokeColor: strokeColor, fillColor: .clear, lineWidth: lineWidth + lineWidthOffset, lineCap: lineCap)
        
        return layer
    }
    
    /// 基本的圓弧動畫
    /// - Parameters:
    ///   - percent: 百分比
    ///   - duration: 動畫時間
    /// - Returns: CABasicAnimation
    func pathAnimation(percent: CGFloat, duration: Double) -> CABasicAnimation {
        let result = CAAnimation._basicAnimation(keyPath: .strokeEnd, delegate: self, fromValue: 0.0, toValue: percent, duration: duration, repeatCount: 1, fillMode: .forwards, isRemovedOnCompletion: false)
        return result.animation
    }
    
    /// 點擊的功能設定 (要點在半徑範圍 + 點到了哪一個Index)
    /// - Parameters:
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func touchesBeganAction(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var index: Int?
        
        defer {
            shadowView.removeFromSuperview()
            shadowView.layer.sublayers?._removeFromSuperlayer()
            delegate?.donutChartView(self, didSelectedIndex: index)
            touchedShadowLayer(with: index)
        }
        
        guard isFinished,
              let location = touches.first?.location(in: contentView),
              let sublayers = rootLayer.sublayers,
              sublayers.count > 1,
              checkRadiusRange(location: location, center: contentView.center, lineWidth: lineWidth, touchGap: touchGap)
        else {
            return
        }

        index = touchedIndex(startAngle: circleAngle.start, location: location, center: contentView.center)
    }
    
    /// 被點到的Layer產生陰影
    /// - Parameter index: Int?
    func touchedShadowLayer(with index: Int?) {
        
        guard let index = index,
              let info = delegate?.informations(in: self)[safe: index],
              let chartAngle = chartAngles()[safe: index]
        else {
            return
        }
        
        let startAngle = chartAngle.start + circleAngle.start
        let endAngle = chartAngle.end + circleAngle.start
        let layer = baseShapeLayer(from: startAngle, to: endAngle, strokeColor: info.strokeColor, lineCap: lineCap, lineWidthOffset: 10)
        
        layer._shadow(color: .lightGray, backgroundColor: .clear, offset: CGSize(width: 2, height: 2), opacity: 1.0, radius: 5.0, cornerRadius: 0)
        shadowView.layer.addSublayer(layer)
        
        addSubview(shadowView)
    }
    
    /// 點擊位置的角度 (0° ~ 360°)
    /// - Parameters:
    ///   - startAngle: CGFloat
    ///   - location: CGPoint
    ///   - center: CGPoint
    /// - Returns: CGFloat
    func touchAngle(startAngle: CGFloat, location: CGPoint, center: CGPoint) -> CGFloat {
        
        let distance = location - center
        var angle = atan2(distance.y, distance.x)._angle()
        
        if (angle < 0) { angle += 360 }
        angle -= startAngle
        if (angle > 360) { angle -= 360 }
        
        return angle
    }
    
    /// 測試碰到哪一個資料的Index (角度範圍)
    /// - Parameters:
    ///   - startAngle: CGFloat
    ///   - location: CGPoint
    ///   - center: CGPoint
    /// - Returns: Int?
    func touchedIndex(startAngle: CGFloat, location: CGPoint, center: CGPoint) -> Int? {
        
        let chartAngles = chartAngles()
        let angle = touchAngle(startAngle: startAngle, location: location, center: contentView.center)
        
        var touchedIndex: Int? = nil
        
        for (index, chartAngle) in chartAngles.enumerated() {
            
            if (angle > chartAngle.start) {
                if (angle < chartAngle.end) {
                    touchedIndex = index
                }
            }
        }
        
        return touchedIndex
    }
    
    /// 計算出各資料上的甜甜圈圖角度 (觸碰用)
    /// - Returns: [ChartAngle]
    func chartAngles() -> [ChartAngle] {
        
        guard let infos = delegate?.informations(in: self) else { return [] }
        
        var chartAngles: [ChartAngle] = []
        var _startAngle = 0.0
        var _percent = 0.0

        for (index, info) in infos.enumerated() {
            
            _startAngle = (CGFloat.pi * 2 * _percent)._angle()
            _percent += info.percent
            
            let _endAngle = (CGFloat.pi * 2 * _percent)._angle()
            
            chartAngles.append((start: _startAngle, end: _endAngle))
        }
        
        return chartAngles
    }
    
    /// 確認點擊的位置 (半徑範圍)
    /// - Parameters:
    ///   - location: CGPoint
    ///   - center: CGPoint
    ///   - lineWidth: CGFloat
    ///   - touchGap: 園環範圍內縮的距離
    /// - Returns: Bool
    func checkRadiusRange(location: CGPoint, center: CGPoint, lineWidth: CGFloat, touchGap: CGFloat) -> Bool {
        
        let distance = location - center
        let radius = distance._radius()
        
        if (radius > center.x - touchGap) { return false }
        if (radius < center.x - lineWidth + touchGap) { return false }
        
        return true
    }
    
    /// 測試動畫是否完全停止
    /// - Parameter flags: [Bool]
    /// - Returns: Bool
    func checkAnimationStop(flags: [Bool]) -> Bool {
        
        guard let totalDuration = delegate?.duration(in: self),
              flags.count == animationLayerCount()
        else {
            return false
        }
        
        return true
    }
    
    /// 動畫Layer的數量 (不含底圈的Layer)
    /// - Returns: Int
    func animationLayerCount() -> Int {
        guard let sublayers = rootLayer.sublayers else { return 0 }
        return sublayers.count - 1
    }
}


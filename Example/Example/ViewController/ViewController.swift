//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/6/20.
//  Copyright © 2024年 William-Weng. All rights reserved.

import UIKit
import WWPrint
import WWDonutChartView

// MARK: MyDonutChartView
final class MyDonutChartView: WWDonutChartView {}

// MARK: ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var touchedIndexLabel: UILabel!
    @IBOutlet weak var donutChartView: MyDonutChartView!
    
    private let infos: [WWDonutChartView.LineInformation] = [
        (title: "Red", strokeColor: .red, percent: 0.1),
        (title: "Green", strokeColor: .green, percent: 0.3),
        (title: "Yellow", strokeColor: .yellow, percent: 0.6),
    ]
    
    private var lineWidthType: WWDonutChartView.LineWidthType = .custom(56)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donutChartView.delegate = self
    }
    
    @IBAction func toggleLineWidthType(_ sender: UIBarButtonItem) {
        
        lineWidthType = (sender.tag == 101) ? .custom(56) : .radius
        
        donutChartView.setting(lineWidthType: lineWidthType, baseLineColor: .lightGray, touchGap: 0)
        donutChartView.clean()
    }
    
    @IBAction func drawAction(_ sender: UIButton) {
        
        let animtionType: WWDonutChartView.AnimtionType
        
        switch lineWidthType {
        case .radius: animtionType = .queue
        case .custom(_): animtionType = .same
        }
        
        donutChartView.drawing(lineCap: .butt, animtionType: animtionType)
    }
}

// MARK: WWDonutChartViewDelegate
extension ViewController: WWDonutChartViewDelegate {
    
    func duration(in donutChartView: WWDonutChartView) -> Double {
        return 1.0
    }
    
    func informations(in donutChartView: WWDonutChartView) -> [WWDonutChartView.LineInformation] {
        return infos
    }
    
    func donutChartView(_ donutChartView: WWDonutChartView, didSelectedIndex index: Int?) {
        
        guard let index = index else { touchedIndexLabel.text = "<null>"; return }
        
        let info = infos[index]
        touchedIndexLabel.text = info.title
    }
    
    func donutChartView(_ donutChartView: WWDonutChartView, animation: CAAnimation, didStop isStop: Bool, isFinished: Bool) {
        wwPrint("\(animation.duration) isStop => \(isStop) => isFinished => \(isFinished)")
    }
}

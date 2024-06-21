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
        (title: "紅色", strokeColor: .red, percent: 0.1),
        (title: "綠色", strokeColor: .green, percent: 0.3),
        (title: "黃色", strokeColor: .yellow, percent: 0.5),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donutChartView.delegate = self
    }
    
    @IBAction func drawAction(_ sender: UIButton) {
        donutChartView.drawing(lineCap: .butt, animtionType: .queue)
    }
}

// MARK: WWDonutChartViewDelegate
extension ViewController: WWDonutChartViewDelegate {
    
    func duration(in donutChartView: WWDonutChartView) -> Double {
        return 2.0
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

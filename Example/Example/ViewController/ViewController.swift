//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/6/20.
//  Copyright © 2024年 William-Weng. All rights reserved.

import UIKit
import WWDonutChartView

// MARK: MyDonutChartView
final class MyDonutChartView: WWDonutChartView {}

// MARK: ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var shapeLayerView: MyDonutChartView!
    
    private let infos: [WWDonutChartView.LineInformation] = [
        (strokeColor: .red, percent: 0.1, duration: 0.25),
        (strokeColor: .green, percent: 0.3, duration: 0.75),
        (strokeColor: .yellow, percent: 0.6, duration: 1.5),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shapeLayerView.delegate = self
    }
    
    @IBAction func drawAction(_ sender: UIButton) {
        shapeLayerView.drawing(lineCap: .butt)
    }
}

// MARK: WWDonutChartViewDelegate
extension ViewController: WWDonutChartViewDelegate {
    
    func informations(in donutChartView: WWDonutChartView) -> [WWDonutChartView.LineInformation] {
        return infos
    }
}

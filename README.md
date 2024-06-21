# WWDonutChartView

[![Swift-5.6](https://img.shields.io/badge/Swift-5.6-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-14.0](https://img.shields.io/badge/iOS-14.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWDonutChartView) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- [Simple donut chart.](https://blog.vizdata.tw/2018/02/how-to_26.html)
- [簡單的甜甜圈圖表。](https://www.canva.com/zh_tw/graphs/doughnut-charts/)

![WWDonutChartView](./Example.gif)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```
dependencies: [
    .package(url: "https://github.com/William-Weng/WWDonutChartView.git", .upToNextMajor(from: "1.1.0"))
]
```

![](./IBDesignable.png)

## [Function - 可用函式](https://gitbook.swiftgg.team/swift/swift-jiao-cheng)
|函式|功能|
|-|-|
|setting(lineWidth:baseLineColor:touchGap)|設定線寬 / 底線的顏色 / 內縮距離|
|drawing(lineCap:animtionType:)|繪製動畫線條 / 動畫類型|
|clean()|清除線段|

## WWDonutChartViewDelegate
|函式|功能|
|-|-|
|duration(in:)|總動畫時間|
|informations(in:)|取得資料相關資訊|
|donutChartView(_:didSelectedIndex:)|點到哪一個圓環的Index|
|donutChartView(_:animation:isStop:isFinished:)|動畫開始 / 停止 / 結束|

## Example
```swift
import UIKit
import WWPrint
import WWDonutChartView

final class MyDonutChartView: WWDonutChartView {}

final class ViewController: UIViewController {
    
    @IBOutlet weak var touchedIndexLabel: UILabel!
    @IBOutlet weak var donutChartView: MyDonutChartView!
    
    private let infos: [WWDonutChartView.LineInformation] = [
        (title: "紅色", strokeColor: .red, percent: 0.1),
        (title: "綠色", strokeColor: .green, percent: 0.3),
        (title: "黃色", strokeColor: .yellow, percent: 0.6),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donutChartView.delegate = self
    }
    
    @IBAction func drawAction(_ sender: UIButton) {
        donutChartView.drawing(lineCap: .butt, animtionType: .queue)
    }
}

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
```

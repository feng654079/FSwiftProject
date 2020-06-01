//
//  SBRadarView.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/6/1.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

protocol SBRadarViewDataSource :NSObjectProtocol{
    
    ///每条数据有几项属性
    func numOfAttributesPerItem(for radarView:SBRadarView) -> Int
    
    //获取每个条目的描述,注意返回数组的元素个数必须和numOfAttributesPerItem 相同
    func itemTexts(for radarView:SBRadarView) -> [NSString]
    
    //获取每个条目的背景颜色,注意返回数组的元素个数必须和numOfAttributesPerItem 相同
    func itemDataColors(for radarView:SBRadarView) -> [UIColor]
    
    //一共有几条数据
    func numOfItems(for radarView:SBRadarView) -> Int
    
    //获取每个条目的数据,注意返回数组的元素个数必须和numOfAttributesPerItem 相同
    func itemData(for radarView:SBRadarView ,at itemIndex:Int) -> [CGFloat]
    
}

@IBDesignable
class SBRadarView: SBChart {
    weak var dataSource:SBRadarViewDataSource?
    
    lazy var maxValue:CGFloat = 100.00
    lazy var speraLineColor:UIColor = .white
    lazy var textColor:UIColor = .black
    lazy var textFont:UIFont = UIFont.systemFont(ofSize: 10.0)
    lazy var bgFillColor:UIColor = UIColor.white.withAlphaComponent(0.3)
    lazy var bgStrokeColor:UIColor = UIColor.init(white: 0.5, alpha: 0.3)
    
    private lazy var _numOfAttributesPerItem:Int = 0
    private lazy var _numOfItems:Int = 0
    private lazy var _itemDatas = [[CGFloat]]()
    private lazy var _itemTexts = [NSString]()
    private lazy var _itemColors = [UIColor]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    
    func commonInit() {
        
    }
    
    override func layoutSubviews() {
        self.chartOrigin = CGPoint(x: 0.5 * self.bounds.width, y: 0.5 * self.bounds.height)
        _reDisplay()
    }
    
  
    
    
    func reloadData() {
        _resetState()
        
        if let dataSource = self.dataSource {
            _numOfAttributesPerItem = dataSource.numOfAttributesPerItem(for: self)
            if _numOfAttributesPerItem > 0 {
                let aItemText = dataSource.itemTexts(for: self)
                if _numOfAttributesPerItem != aItemText.count {
                    fatalError("itemText return's [NSString].count must be equal to numOfAttributesPerItem.")
                }
                
                _numOfItems = dataSource.numOfItems(for: self)
                
                let aItemColors = dataSource.itemDataColors(for: self)
                if aItemColors.count != _numOfItems {
                    fatalError("itemDataColors return's [UIColor].count must be equal to  numOfItems.")
                }
                
                for idx in 0..<_numOfItems {
                    let aItemData = dataSource.itemData(for: self, at: idx)
                    if _numOfAttributesPerItem != aItemData.count {
                        fatalError("itemData return's [CGFloat].count must be equal to numOfAttributesPerItem.")
                    }
                    self._itemDatas.append(aItemData)
                }
                self._itemColors = aItemColors
                self._itemTexts = aItemText
                self.showAnimation()
            }
        }
    }
    
    override func showAnimation() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func clear() {
        _resetState()
        _reDisplay()
    }
    
    private func _resetState() {
          _numOfItems = 0
          _numOfAttributesPerItem = 0
          _itemDatas.removeAll()
          _itemTexts.removeAll()
          _itemColors.removeAll()
          
          for view in self.subviews {
              view.removeFromSuperview()
          }
          
          if let sublayers = self.layer.sublayers {
              for layer in sublayers {
                  layer.removeFromSuperlayer()
              }
          }
      }
      
      private func _reDisplay() {
          
          let layerCount = 5
          
          let perAngle = 2.0 * CGFloat.pi / CGFloat(_numOfAttributesPerItem)
          
          let chartRadius = (min(self.bounds.width,self.bounds.height) - 50.0 * 2) * 0.5
          let perLength = chartRadius / CGFloat(layerCount)
          
          
          //draw texts and  get base drawpoints
          var baseDrawPoints = [[CGPoint]]()
          for idx in 0..<layerCount {
              var cacheArr = [CGPoint]()
              let cacheLength = CGFloat(idx + 1) * perLength
              
              for internal_idx in 0..<_numOfAttributesPerItem {
                  
                  let point = CGPoint(x: self.chartOrigin.x + CGFloat(sin(Double(CGFloat(internal_idx) * perAngle))) * cacheLength, y: self.chartOrigin.y - CGFloat(cos(Double(CGFloat(internal_idx) * perAngle))) * cacheLength)
                  cacheArr.append(point)
                  
                  if idx == 0 {
                      let font = textFont
                      let width = self.size(of: _itemTexts[internal_idx], limitSize: CGSize(width: 100, height: 20), font: font).width
                      let cacheLabel = UILabel(frame:CGRect(x: 0, y: 0, width: width, height: 20))
                      cacheLabel.font = textFont
                      cacheLabel.center = CGPoint(x:self.chartOrigin.x + CGFloat(chartRadius + width / 2.0 + 5.0) * sin(CGFloat(internal_idx) * perAngle) ,
                                                  y: CGFloat(self.chartOrigin.y - (chartRadius + 20.0 / 2.0 + 5.0) * cos(CGFloat(internal_idx) * perAngle)))
                      cacheLabel.text = _itemTexts[internal_idx] as String
                      cacheLabel.textColor = textColor
                      self.addSubview(cacheLabel)
                  }
              }
              
              baseDrawPoints.append(cacheArr)
          }
          
          
          
          // get draw points
          var drawPointArr = [[CGPoint]]()
          for i in 0..<_itemDatas.count {
              
              let itemData = _itemDatas[i]
              var cacheArr = [CGPoint]()
              
              for j in 0..<itemData.count {
                  var value = itemData[j]
                  value = min(value, maxValue)
                  let cachePoint = CGPoint(x: self.chartOrigin.x + value / maxValue * chartRadius * sin(CGFloat(j) * perAngle), y: self.chartOrigin.y - value / maxValue * chartRadius * cos(CGFloat(j)*perAngle))
                  cacheArr.append(cachePoint)
              }
              
              drawPointArr.append(cacheArr)
          }
          
          //draw backgroud
          for i in 0..<baseDrawPoints.count {
              let shape = CAShapeLayer()
              let path = UIBezierPath()
              let cachedArray = baseDrawPoints[i]
              for j in 0..<cachedArray.count {
                  if j == 0 {
                      path.move(to: cachedArray[j])
                  }
                  else {
                      path.addLine(to: cachedArray[j])
                  }
              }
              path.close()
              shape.path = path.cgPath
            shape.fillColor = bgFillColor.cgColor
            shape.strokeColor = bgStrokeColor.cgColor
            self.layer.addSublayer(shape)
          }
          
          
          //draw seprar line
          do {
              let shape = CAShapeLayer()
              let path = UIBezierPath()
              let cachedArray = baseDrawPoints.last ?? []
              for i in 0..<cachedArray.count {
                  path.move(to: self.chartOrigin)
                  path.addLine(to: cachedArray[i])
              }
              
              shape.path = path.cgPath
              shape.fillColor = UIColor.clear.cgColor
              shape.strokeColor = speraLineColor.cgColor
              self.layer.addSublayer(shape)
          }
          
          
          
          
          //draw data layers
          for i in 0..<drawPointArr.count {
              let shape = CAShapeLayer()
              let path = UIBezierPath()
              let cachedArray = drawPointArr[i]
              for j in 0..<cachedArray.count {
                  if j == 0 {
                      path.move(to: cachedArray[j])
                  }
                  else {
                      path.addLine(to: cachedArray[j])
                  }
              }
              path.close()
              shape.path = path.cgPath
            shape.fillColor = _itemColors[i].cgColor
              shape.strokeColor = UIColor.init(white: 0.5, alpha: 0.3).cgColor
              self.layer.addSublayer(shape)
          }
      }
}

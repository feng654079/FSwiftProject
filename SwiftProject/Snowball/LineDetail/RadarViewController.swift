//
//  RadarViewController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/6/1.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

class RadarViewController: UIViewController {
    
    static func create() -> RadarViewController {
        return self.create(fromStoryboardName: "Snowball", identifier: "RadarViewController") as! RadarViewController
    }
    
    @IBOutlet weak var radarView: SBRadarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpUI()
    }
    
    private func _setUpUI() {
        radarView.dataSource = self
        radarView.bgFillColor = UIColor.init(white: 0.5, alpha: 0.3)
        radarView.speraLineColor = UIColor.purple
        radarView.textColor = UIColor.lightGray
        radarView.reloadData()
    }
}

extension RadarViewController:SBRadarViewDataSource {
  
    func numOfItems(for radarView: SBRadarView) -> Int {
        2
    }
    
    func itemDataColors(for radarView: SBRadarView) -> [UIColor] {
        return [UIColor.red.withAlphaComponent(0.5),UIColor.blue.withAlphaComponent(0.3)]
    }
    
    
    func numOfAttributesPerItem(for radarView: SBRadarView) -> Int {
        6
    }
    
    func itemTexts(for radarView: SBRadarView) -> [NSString] {
        let result = ["击杀","助攻","补刀","推塔","视野","其它"]
        return result as [NSString]
    }

    
    func itemData(for radarView: SBRadarView, at itemIndex: Int) -> [CGFloat] {
        let result:[[CGFloat]] = [[40.0,90.0,70.0,80.0,30.0,80.0],[60.0,40.0,50.0,30.0,80.0,40.0]]
        return result[itemIndex]
    }
    
    
}

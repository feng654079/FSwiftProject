//
//  SBTimelineViewController.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/26.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import SwiftyJSON

class SBHotTimelineViewController:UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
   static func create() -> SBHotTimelineViewController {
        return SBHotTimelineViewController.create(fromStoryboardName: "Snowball", identifier: "SBHotTimelineViewController") as! SBHotTimelineViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
        if let path = Bundle.main.path(forResource: "Timeline.json", ofType: nil),
           let jsonData = try? Data(contentsOf:URL(fileURLWithPath: path)) {
            
            do {
                let mJSON = try JSON.init(data: jsonData)
                debugPrint(mJSON)
            }catch(let error) {
               debugPrint(error)
            }
          
        }
      
        
    }
    
    func setUpUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(reuseID: SBTimelineTableViewCell.self, nibName: "SBTimelineTableViewCell")
    }
    
    
}

extension SBHotTimelineViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SBTimelineTableViewCell.reuseID) as? SBTimelineTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.refreshUI(with: "我是一段内容", title: nil, quoteCommand: nil, imageUrlList: ["icon_logo"], sharesInfo: "")
            
        } else if indexPath.row == 1 {
            
              cell.refreshUI(with: "3月24日，陕西渭南的潼关县开始收割小麦，标志着今年的“关中第一镰”正式开镰收割，陕西省“三夏”大规模麦收也将由东向西陆续展开。在潼关县秦东镇港口社区西厫一组一台小型收割机@关晓彤 @特朗普 来回穿梭在田间地头忙碌地作业今年收割采用的是$小型履带式收割机$,更加适宜这里的块式地形，不仅抢收效率高,时间快,收割后群众可直接装进袋子大大减少了劳力.", title: "关中第一镰”开镰 抢收效率高", quoteCommand: nil, imageUrlList:  ["icon_logo","icon_read_coffee"], sharesInfo: "")
            
            
        } else {
            
            cell.refreshUI(with: "这两天，江苏境内的小麦#逐渐进入成熟期#，自南向北陆续收割。在$江苏省南通(SZ002304)$市港闸区，6500亩小麦从上周开始正式收割，得益于现代化的农业生产管理手段悬赏[¥199.56]，这两年这里已实现旋耕、种植、收割等全过程的100%机械化作业，一个人就可轻松管理上千亩农田。", title: nil, quoteCommand: "目前，江苏省小麦苗情长势为近6年最好，如果后期天气正常，今年江苏夏粮也将迎来丰收。", imageUrlList: nil, sharesInfo: "")
        }
      
        return cell
    }
    
}

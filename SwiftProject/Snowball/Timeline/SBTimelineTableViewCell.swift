//
//  SBTimelineTableViewCell.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/26.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit
import YYKit

//MARK:-
protocol SBTimelineTableViewCellDataProvider {
    var p_title:String? { get }
    var p_content:String { get }
    var p_quota:String { get }
    var p_imgUrlList: [String]? { get }
    
    var p_itemName: String? { get }
    var p_itemRatio: CGFloat? { get }
}

//MARK:-
@IBDesignable
class ImageContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    
    func commonInit() {
        //self.refresuUI(with: ["icon_logo","icon_read_coffee"])
    }
    
    func refresuUI(with imageUrlList:[String]) {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        let imgWidth:CGFloat = imageUrlList.count == 1 ? 0.7 : 0.3
        let imgHeight:CGFloat = imageUrlList.count == 1 ? 120.hs:80.hs
        let imgMargin:CGFloat = imageUrlList.count == 1 ? 10.hs : 2.hs
        
        let count = imageUrlList.count > 3 ? 3 : imageUrlList.count
        for idx in 0..<count {
            let leadingAnchor = idx == 0 ? self.leadingAnchor : self.subviews[idx - 1].trailingAnchor
            let imgView = UIImageView(frame: .zero)
            imgView.image = UIImage(named: imageUrlList[idx])
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(imgView)
            
            imgView.leadingAnchor.constraint(equalTo:leadingAnchor,constant: imgMargin).isActive = true
            imgView.topAnchor.constraint(equalTo: self.topAnchor,constant: imgMargin).isActive = true
            imgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: imgWidth).isActive = true
            imgView.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
            imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -imgMargin).isActive = true
        }
        
    }
}

//MARK:-
//@IBDesignable
class SBTimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImgv: UIImageView!
    @IBOutlet weak var avatarTypeImgv: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: YYLabel!
    @IBOutlet weak var contentLbl: YYLabel!
    
    @IBOutlet weak var sharesVw: UIView!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var quoteCommentLbl: YYLabel!
    
    @IBOutlet weak var contenContainer: UIStackView!
    
    @IBOutlet weak var imageContainerVw: ImageContainerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commonInit()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        debugPrint("prepareForReuse")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
    func commonInit() {
        
        self.selectionStyle = .none
        
        self.avatarImgv.layer.cornerRadius = 25.0
        self.avatarImgv.layer.borderWidth = 1.0
        self.avatarImgv.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let labelLayoutMaxWidth = 345.hs
        
        self.titleLbl.preferredMaxLayoutWidth = labelLayoutMaxWidth
        self.contentLbl.preferredMaxLayoutWidth = labelLayoutMaxWidth
        self.quoteCommentLbl.preferredMaxLayoutWidth = labelLayoutMaxWidth
        // self.sharesVw.isHidden = true
        
        self.contentLbl.highlightTapAction = {
           [weak self] (containerView, text, range,rect) in
            debugPrint(text.attributedSubstring(from: range))
        }
    }
    
    @IBAction func sharedBtnTouched(_ sender: UIButton) {
    }
    
    
    @IBAction func commentBtnTouched(_ sender: UIButton) {
    }
    
    @IBAction func supportBtnTouched(_ sender: UIButton) {
    }
    
    @IBAction func moreBtnTouched(_ sender: UIButton) {
    }
    
    
    func refreshUI(with content:String ,
                   title:String? ,
                   quoteCommand:String? ,
                   imageUrlList:[String]?,sharesInfo:String) {
        // resetItem()
        self.contentLbl.attributedText = attributeString(for: content)
        
        self.titleLbl.text = title
        self.titleLbl.isHidden = title == nil
        
        self.quoteCommentLbl.text = quoteCommand
        self.quoteCommentLbl.isHidden = quoteCommand == nil
        
        //self.imageContainerVw.isHidden = true
        if let imageUrlList = imageUrlList {
            self.imageContainerVw.isHidden = imageUrlList.count == 0
            self.imageContainerVw.refresuUI(with: imageUrlList)
        }
        
        self.setNeedsLayout()
    }
    
    func attributeString(for title:String?) -> NSAttributedString? {
        
        guard let title  = title else {
            return nil
        }
        
        let attributeString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.Font(name: .pingfangsc_semibold, size: 15.0),NSAttributedString.Key.foregroundColor:UIColor.black])
        
        let patterns = ["\\$.+\\$","\\@[\\u4e00-\\u9fa50-9a-zA-Z]+","\\#.+\\#","悬赏\\[¥[0-9]{1,}\\.[0-9]*\\]"]
        
        title.match(with: patterns) { (result, flags, pointer) in
            attributeString.setTextHighlight(result.range, color: UIColor.blue, backgroundColor: UIColor.lightGray,tapAction: nil)
        }
        
        return attributeString

    }
    
}

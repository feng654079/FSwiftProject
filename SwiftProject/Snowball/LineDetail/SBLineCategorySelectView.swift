//
//  SBLineCategorySelectView.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/28.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation



@IBDesignable
class SBLineCategorySelectView:UIView {
    typealias TouchedHanlder = (Int) -> Void
    
    //MARK:-
    private let scrollVw = UIScrollView(frame: .zero)
    private let containerStackView = UIStackView.init(frame: .zero)
    private let buoyVw = UIView(frame: .zero)
    
    private var normalTextColor = UIColor.gray
    private var selectedTextColor = UIColor.black
    private var normalFont = UIFont.Font(name: .pingfangsc_regular, size: 15.0)
    private var selectedFont = UIFont.Font(name: .pingfangsc_semibold, size: 15.0)
    
    private var lastSelectedBtn:UIButton?
    private var buoyVwCenterX:NSLayoutConstraint?
    private var touchedHandler:TouchedHanlder?
    
    //MARK:-
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        
        scrollVw.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        buoyVw.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollVw)
        scrollVw.addSubview(containerStackView)
        scrollVw.addSubview(buoyVw)
        
        scrollVw.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollVw.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollVw.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollVw.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollVw.showsHorizontalScrollIndicator = false
        
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.axis = .horizontal
        
        let spacing:CGFloat = 20.0
        containerStackView.spacing = spacing
        
        containerStackView.leadingAnchor.constraint(equalTo: self.scrollVw.leadingAnchor ,constant: spacing).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: self.scrollVw.trailingAnchor,constant: -spacing).isActive = true
        containerStackView.topAnchor.constraint(equalTo: self.scrollVw.topAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: self.scrollVw.bottomAnchor).isActive = true
        containerStackView.heightAnchor.constraint(equalTo: self.scrollVw.heightAnchor,constant:  -5.0).isActive = true;
        
        
        buoyVw.layer.cornerRadius = 2.0
        buoyVw.clipsToBounds = true
        buoyVw.widthAnchor.constraint(equalToConstant: 8.0).isActive = true
        buoyVw.heightAnchor.constraint(equalToConstant: 4.0).isActive = true
        buoyVw.bottomAnchor.constraint(equalTo: self.scrollVw.bottomAnchor).isActive = true
        
       
    }
    
    override func layoutSubviews() {
        _adjustScrollViewContentOffsetX()
    }
    
    func config(titles:[String],
                normalTextColor:UIColor? = nil,
                selectedTextColor:UIColor? = nil,
                normalFont:UIFont? = nil,
                selectedFont: UIFont? = nil,
                touchedHandler:@escaping TouchedHanlder) {
        
        for btn in containerStackView.arrangedSubviews {
            btn.removeFromSuperview()
        }
        
        guard titles.count > 0 else {
            return
        }
        self.touchedHandler = touchedHandler
        
        let _normalTextColor = normalTextColor ?? UIColor.gray
        let _selectedTextColor = selectedTextColor ?? UIColor.black
        let _normalFont = normalFont ??  UIFont.Font(name: .pingfangsc_regular, size: 15.0)
        let _selectedFont = selectedFont ?? UIFont.Font(name: .pingfangsc_semibold, size: 15.0)
        
        buoyVw.backgroundColor = _selectedTextColor
        
        for idx in 0..<titles.count {
            let btn = UIButton(frame: .zero)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitleColor(_normalTextColor, for: .normal)
            btn.setTitleColor(_selectedTextColor, for: .selected)
            btn.titleLabel?.font = normalFont
            btn.setTitle(titles[idx], for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false;
            btn.addTarget(self, action: #selector(btnTouched(sender:)), for: .touchUpInside)
            btn.tag = idx
            containerStackView.addArrangedSubview(btn)
            
            if (idx == 0) {
                btn.isSelected = true
                btn.titleLabel?.font = _selectedFont
                lastSelectedBtn = btn
                self._alignBuoyVwCenterX(with: btn)
            }
            
        }
        
        self.normalTextColor = _normalTextColor
        self.selectedTextColor = _selectedTextColor
        self.normalFont = _normalFont
        self.selectedFont = _selectedFont
        
    }
    
    
    @objc private func btnTouched(sender :UIButton) {
        
        if sender.isSelected == false {
            lastSelectedBtn?.isSelected = false
            lastSelectedBtn?.titleLabel?.font = self.normalFont
            
            sender.isSelected = true
            sender.titleLabel?.font = self.selectedFont
            self._alignBuoyVwCenterX(with: sender)
            
            lastSelectedBtn = sender
            
            self.touchedHandler?(sender.tag)
            
        }
    }
    
    //MARK:-
    private  func _alignBuoyVwCenterX(with item:UIView) {
           if let buoyVwCenterX = self.buoyVwCenterX {
               self.scrollVw.removeConstraint(buoyVwCenterX)
               
               UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                   [weak self] in
                   self?.buoyVwCenterX = self?.buoyVw.centerXAnchor.constraint(equalTo: item.centerXAnchor)
                   self?.buoyVwCenterX?.isActive = true
                   self?.scrollVw.layoutIfNeeded()
                   self?.setNeedsLayout()
                   self?.layoutIfNeeded()
               })
               
           }
           else {
               self.buoyVwCenterX = buoyVw.centerXAnchor.constraint(equalTo: item.centerXAnchor)
               self.buoyVwCenterX?.isActive = true
           }
       }
       
       private func _adjustScrollViewContentOffsetX() {
           let maxRightOffset = self.scrollVw.contentSize.width - self.bounds.width
           let needScrollToRight = buoyVw.center.x > scrollVw.contentOffset.x + 0.5 * self.bounds.width
               && self.scrollVw.contentOffset.x < maxRightOffset
           let needScroolToLeft =  buoyVw.center.x < scrollVw.contentOffset.x + 0.5 * self.bounds.width && scrollVw.contentOffset.x > 0
           if needScrollToRight || needScroolToLeft  {
               var offSetX = buoyVw.center.x - 0.5 * self.bounds.width
               if needScroolToLeft {
                   offSetX = max(offSetX, 0)
               } else if needScrollToRight {
                   offSetX = min(offSetX, maxRightOffset)
               }
               
               self.scrollVw.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
           }
       }
}

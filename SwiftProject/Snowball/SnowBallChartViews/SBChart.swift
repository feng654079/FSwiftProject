//
//  SBChart.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/6/1.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import UIKit

class SBChart: UIView {
    
    /**
    *  The margin value of the content view chart view
    *  图表的边界值
    */
    lazy var contentInset:UIEdgeInsets = .zero
    
    /**
    *  The origin of the chart is different from the meaning of the origin of the chart.
       As a pie chart and graph center ring. The line graph represents the origin.
    *  图表的原点值（如果需要）
    */
    lazy var chartOrigin:CGPoint = .zero
    
    /**
    *  Name of chart. The name is generally not displayed, just reserved fields
    *  图表名称
    */
    lazy var chartTitle:NSString = ""
    
    /**
    *  The fontsize of Y line text.Default id 8;
    */
    lazy var yDescTextFontSize:CGFloat = 8.0
    
    /**
    *  The fontsize of X line text.Default id 8;
    */
    lazy var xDescTextFontSize:CGFloat = 8.0
    
    /*!
    * if animationDuration <= 0,this chart will display without animation.Default is 2.0;
    */
    lazy var animationDuration:TimeInterval = 2.0

    /**
    *  X, Y axis line color
    */
    lazy var xAndYLineColor = UIColor.blue
    
    //subclass implement
    func showAnimation() {}
    
    //subclass implemtn
    func clear() {}
}


//MARK:- SBChart draw methods
extension SBChart {
  
    
    // draw line
    func drawLine(with context:CGContext,
                  startPoint:CGPoint,
                  endPoint:CGPoint,
                  isDotted:Bool,
                  color:UIColor) {
        
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.setLineWidth(0.3)
        color.setStroke()
        if isDotted {
            let ss:[CGFloat] = [1.5,2]
            context.setLineDash(phase: 0.0, lengths: ss)
        }
        context.move(to: endPoint)
        context.drawPath(using: .fill)
    }
    
    //绘制文本
    func drawText(with context:CGContext,text:NSString,at point:CGPoint,color:UIColor,font:UIFont) {
        NSString(format: "%@", text).draw(at: point, withAttributes: [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:color])
        color.setFill()
        context.drawPath(using: .fill)
    }
    
    
    //绘制矩形
    func drawQuart(with context:CGContext,at rect:CGRect,strokeColor:UIColor , fillColor:UIColor) {
        context.addRect(rect)
        strokeColor.setStroke()
        fillColor.setFill()
        context.drawPath(using: .fillStroke)
    }
    
    //绘制一个圆形点
    func drawPoint(with context:CGContext,at center:CGPoint,radius:CGFloat ,fillColor:UIColor) {
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        fillColor.setFill()
        context.drawPath(using: .fill)
    }
    
    func size(of text:NSString,limitSize:CGSize,font:UIFont) -> CGSize {
        let size = NSString(format: "%@", text).boundingRect(with: limitSize, options: [.usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil).size
        return size
    }
}

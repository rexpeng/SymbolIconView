//
//  SimpleIcon.swift
//  animationview
//
//  Created by Rex Peng on 2019/11/1.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

enum SymbolType {
    case checkmark, error, exclamation, question
}

class SymbolIconView: UIView {
    
    private var viewCenter: CGPoint {
        return CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
    }
    private var width: CGFloat {
        return bounds.width
    }
    private var height: CGFloat {
        return bounds.height
    }
    private var radius: CGFloat {
        return min(width*0.5, height*0.5)
    }
    private var viewSymbolType: SymbolType = .checkmark
    private var isAnimation: Bool = true
    private var viewLineWidth: CGFloat = 4
    
    init(frame: CGRect, symbolType: SymbolType, animation: Bool = true, lineWidth: CGFloat = 4) {
        super.init(frame: frame)
        self.viewSymbolType = symbolType
        self.isAnimation = animation
        self.viewLineWidth = lineWidth
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        layer.sublayers = nil
        
        drawChecSymbol(symbolType: viewSymbolType, lineWidth: viewLineWidth, animation: isAnimation)
    }
    
    func reDraw() {
        setNeedsDisplay()
    }
    
    private func drawChecSymbol(symbolType: SymbolType, strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat = 4, animation: Bool = true, repeatCount: Float = 1, duration: CFTimeInterval = 1) {
        let circle = circleLayer(strokeColor: strokeColor, lineWidth: lineWidth)
        var symbol : CAShapeLayer
        switch symbolType {
        case .checkmark:
            symbol = checkMarkLayer(strokeColor: strokeColor, lineWidth: lineWidth)
        case .error:
            symbol = xSymbolLayer(strokeColor: strokeColor, lineWidth: lineWidth)
        case .exclamation:
            symbol = exclamationLayer(strokeColor: strokeColor, lineWidth: lineWidth)
        case .question:
            symbol = questionLayer(strokeColor: strokeColor, lineWidth: lineWidth)
        }
        let _animation = strokeAnimation(repeatCount: repeatCount, duration: duration)
        if animation {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                symbol.add(_animation, forKey: nil)
                self.layer.addSublayer(symbol)
            }
            circle.add(_animation, forKey: nil)
            layer.addSublayer(circle)
            CATransaction.commit()
        } else {
            layer.addSublayer(circle)
            layer.addSublayer(symbol)
        }
    }
    
    private func circlePath() -> CGPath {
        //let radius = min(width*0.5, height*0.5)
        let circle = UIBezierPath(arcCenter: viewCenter, radius: radius, startAngle: getAngle(angle: 0), endAngle: getAngle(angle: 359.9999), clockwise: true)
        return circle.cgPath
    }
    
    private func checkMarkPath() -> CGPath {
        var radius = min(width*0.5, height*0.5)*0.5
        let p1 = getPoint(angle: 270, center: viewCenter, radius: radius)
        radius = min(width*0.5, height*0.5)*0.5
        let p2 = getPoint(angle: 190, center: viewCenter, radius: radius)
        radius = min(width*0.5, height*0.5)*0.7
        let p3 = getPoint(angle: 45, center: viewCenter, radius: radius)
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        return path.cgPath
    }
    
    private func xSymbolPath() -> CGPath {
        let _radius = radius*0.5
        let leftTop = getPoint(angle: 325, center: viewCenter, radius: _radius)
        let rightTop = getPoint(angle: 45, center: viewCenter, radius: _radius)
        let leftBottom = getPoint(angle: 225, center: viewCenter, radius: _radius)
        let rightBottom = getPoint(angle: 135, center: viewCenter, radius: _radius)
        let xPath = UIBezierPath()
        xPath.move(to: leftTop)
        xPath.addLine(to: rightBottom)
        xPath.move(to: rightTop)
        xPath.addLine(to: leftBottom)
        return xPath.cgPath
    }
    
    private func exclamationPath(lineWidth: CGFloat = 1) -> CGPath {
        let offset = width / 14.0
        let quarterHeight = height / 4.0
        let exclamationPath = UIBezierPath()
        exclamationPath.move(to: CGPoint(x: viewCenter.x-lineWidth*0.5, y: viewCenter.y - (quarterHeight * 1.2)))
        exclamationPath.addLine(to: CGPoint(x: viewCenter.x, y: viewCenter.y + (quarterHeight / 2.0)))
        exclamationPath.move(to: CGPoint(x: viewCenter.x+lineWidth*0.5, y: viewCenter.y - (quarterHeight * 1.2)))
        exclamationPath.addLine(to: CGPoint(x: viewCenter.x, y: viewCenter.y + (quarterHeight / 2.0)))

        //exclamationPath.move(to: CGPoint(x: viewCenter.x, y: viewCenter.y - (quarterHeight * 1.2)))
        //exclamationPath.addLine(to: CGPoint(x: viewCenter.x, y: viewCenter.y + (quarterHeight / 2.0)))

        exclamationPath.move(to: CGPoint(x: viewCenter.x, y: viewCenter.y + (quarterHeight / 2.0) + offset))
        exclamationPath.addLine(to: CGPoint(x: viewCenter.x, y: viewCenter.y + (quarterHeight / 2.0) + (offset * 2.5)))
        return exclamationPath.cgPath
    }
    
    private func questionPath(lineWidth: CGFloat = 1) -> CGPath {
        let _radius = radius * 0.7 * 0.5
        let center = CGPoint(x: viewCenter.x, y: viewCenter.y-_radius)
        let questionPath = UIBezierPath()
        questionPath.addArc(withCenter: center, radius: _radius, startAngle: getAngle(angle: 270), endAngle: getAngle(angle: 180), clockwise: true)
        questionPath.addLine(to: CGPoint(x: viewCenter.x, y: viewCenter.y+_radius-lineWidth*0.5))
        questionPath.move(to: CGPoint(x: viewCenter.x, y: viewCenter.y+_radius*1.5))
        questionPath.addLine(to: CGPoint(x: viewCenter.x, y: viewCenter.y+_radius*2+lineWidth*0.25))
        return questionPath.cgPath
    }
    
    private func shapLayer(fillColor: CGColor = UIColor.clear.cgColor, strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat = 1, lineCap: CAShapeLayerLineCap = .butt) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.strokeColor = strokeColor
        layer.lineWidth = lineWidth
        layer.fillColor = fillColor
        layer.lineCap = lineCap
        layer.lineJoin = .round
        return layer
    }
    
    private func circleLayer(/*fillColor: CGColor = UIColor.clear.cgColor,*/ strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat = 1) -> CAShapeLayer {
        
        let circleLayer = shapLayer(/*fillColor: fillColor,*/ strokeColor: strokeColor, lineWidth: lineWidth)
        circleLayer.path = circlePath()
        
        return circleLayer
    }
    
    private func checkMarkLayer(strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat = 1) -> CAShapeLayer {
        
        let checkLayer = shapLayer(strokeColor: strokeColor, lineWidth: lineWidth, lineCap: .round)
        checkLayer.path = checkMarkPath()
        return checkLayer
    }
    
    private func xSymbolLayer(strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat = 1) -> CAShapeLayer {
        let xLayer = shapLayer(strokeColor: strokeColor, lineWidth: lineWidth, lineCap: .round)
        xLayer.path = xSymbolPath()
        return xLayer
    }
    
    private func exclamationLayer(strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat = 1) -> CAShapeLayer {
        let exclamationLayer = shapLayer(strokeColor: strokeColor, lineWidth: lineWidth)
        exclamationLayer.path = exclamationPath(lineWidth: lineWidth)
        return exclamationLayer
    }
    
    private func questionLayer(strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat = 1) -> CAShapeLayer {
        let questionLayer = shapLayer(strokeColor: strokeColor, lineWidth: lineWidth, lineCap: .round)
        questionLayer.path = questionPath(lineWidth: lineWidth)
        return questionLayer
    }
    
    private func getPoint(angle: CGFloat, center: CGPoint, radius: CGFloat) -> CGPoint {
        let mAngle = getAngle(angle: angle)
        let x = center.x + radius * cos(mAngle)
        let y = center.y + radius * sin(mAngle)
        return CGPoint(x: x, y: y)
    }
    
    private func getAngle(angle: CGFloat) -> CGFloat {
        var mAngle = angle - 90.0
        if mAngle > 180.0 {
            mAngle = mAngle - 360.0
        }
        mAngle = mAngle * CGFloat.pi / 180.0
        return mAngle
    }
    
    private func strokeAnimation(repeatCount: Float = 1, duration: CFTimeInterval = 1) -> CABasicAnimation {
       let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.repeatCount = repeatCount
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = 0
        animation.toValue = 1
        return animation
    }

}

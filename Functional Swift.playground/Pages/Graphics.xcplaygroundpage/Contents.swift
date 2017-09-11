//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"

import PlaygroundSupport


//test
let test1 = CGSize.init(width: 1, height: 1).fit(vector: CGVector.init(dx: 0.5, dy: 0.5), CGRect.init(x: 0, y: 0, width: 200, height: 100))
let test2 = CGSize.init(width: 1, height: 1).fit(vector: CGVector.init(dx: 0, dy: 0.5), CGRect.init(x: 0, y: 0, width: 200, height: 100))

///Diagram
// 对所有不同的情况进行匹配分别处理
extension CGContext {
    func draw(bounds:CGRect,_ diagram:Diagram) {
        switch diagram {
        case .Prim(let size, .Ellipse):
            let frame = size.fit(vector: CGVector.init(dx: 0.5, dy: 0.5), bounds)
            self.fillEllipse(in: frame)
        case .Prim(let size, .Rectangle):
            let frame = size.fit(vector: CGVector.init(dx: 0.5, dy: 0.5), bounds)
            self.fill(frame)
        case .Prim(let size, .Text(let text)):
            let frame = size.fit(vector: CGVector.init(dx: 0.5, dy: 0.5), bounds)
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSFontAttributeName:font]
            let attributeText = NSAttributedString.init(string: text, attributes: attributes)
            attributeText.draw(in: frame)
        case .Attributed(.FillColor(let color), let d):
            self.saveGState()
            color.set()
            draw(bounds: bounds, d)
            self.restoreGState()
        case .Beside(let left, let right):
            let ratio = left.size.width / diagram.size.width
            let (lFrame,rFrame) = bounds.split(ratio: ratio, edge: .minXEdge)
            draw(bounds: lFrame, left)
            draw(bounds: rFrame, right)
        case .Below(let top, let bottom):
            let ratio = top.size.height / diagram.size.width
            let (tFrame,bFrame) = bounds.split(ratio: ratio, edge: .minYEdge)
            draw(bounds: tFrame, top)
            draw(bounds: bFrame, bottom)
        case .Align(let vec, let d):
            let frame = d.size.fit(vector: vec, bounds)
            draw(bounds: frame, d)
        }
    }
}

class DrawView : UIView {
    let diagram : Diagram
    
    init(frame:CGRect,d:Diagram) {
        self.diagram = d
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let contex = UIGraphicsGetCurrentContext() else {
            return
        }
        contex.draw(bounds: self.bounds, diagram)
    }
}

let ellipse = Diagram.Attributed(.FillColor(UIColor.red), Diagram.Prim(CGSize.init(width: 100, height: 100), .Ellipse))

let rectangle = Diagram.Attributed(.FillColor(UIColor.blue), Diagram.Prim(CGSize.init(width: 100, height: 50), .Rectangle))
let text = Diagram.Attributed(.FillColor(UIColor.white), Diagram.Prim(CGSize.init(width: 30 , height: 20), .Text("Diagram Test")))

let beside = Diagram.Beside(ellipse, rectangle)
let below = Diagram.Below(beside, text)
let align = Diagram.Align(CGVector.init(dx: 0.5, dy: 0.5), below)

let displayView = DrawView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 300), d: below)
displayView.backgroundColor = UIColor.white


extension Diagram {
    func pdfOut(width:CGFloat) -> Data? {
        let height = width * (self.size.height / self.size.width)
        let v = DrawView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height), d: self)
        let data = NSMutableData.init()
        UIGraphicsBeginPDFContextToData(data, v.bounds, nil)
        UIGraphicsBeginPDFPage()
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        v.layer.render(in: context)
        UIGraphicsEndPDFContext()
        return data as Data
    }
}

let data = below.pdfOut(width: 100)


PlaygroundPage.current.liveView = displayView




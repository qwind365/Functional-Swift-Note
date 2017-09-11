import Foundation
import UIKit

public enum Primitive {
    case Ellipse
    case Rectangle
    case Text(String)
}

public enum Attribute {
    case FillColor(UIColor)
}

public indirect enum Diagram {
    case Prim(CGSize,Primitive)
    case Beside(Diagram,Diagram)
    case Below(Diagram,Diagram)
    case Attributed(Attribute,Diagram)
    case Align(CGVector,Diagram)
    
    public var size:CGSize {
        switch self {
        case .Prim(let size, _):
            return size
        case .Attributed(_, let x):
            return x.size
        case .Beside(let left, let right):
            let lSize = left.size
            let rSize = right.size
            return CGSize.init(width: lSize.width + rSize.width, height: max(lSize.height, rSize.height))
        case .Below(let left, let right):
            let lSize = left.size
            let rSize = right.size
            return CGSize.init(width: max(lSize.width, rSize.width), height: lSize.height + rSize.height)
        case .Align(_, let d):
            return d.size
        }
    }
}



// MARK: - 不想再重新自定义运算符， 直接实现fit方法
public extension CGSize {
    func fit(vector:CGVector,_ rect:CGRect) -> CGRect {
        let widthScale = rect.size.width / self.width
        let heightScale = rect.size.height / self.height
        let scale = min(widthScale, heightScale)
        let size = CGSize.init(width: self.width * scale, height: self.height * scale)
        let space = CGSize.init(width: (size.width - rect.size.width) * vector.dx, height: (size.height - rect.size.height) * vector.dy)
        return CGRect.init(x: rect.origin.x - space.width, y: rect.origin.y - space.height, width: size.width, height: size.height)
    }
}

public extension CGRect {
    func split(ratio:CGFloat,edge:CGRectEdge) -> (CGRect,CGRect) {
        var length:CGFloat = 0
        if edge == .minXEdge || edge == .maxXEdge {
            length = ratio * self.width
        }else {
            length = ratio * self.height
        }
        return divided(atDistance: length, from: edge)
    }
}

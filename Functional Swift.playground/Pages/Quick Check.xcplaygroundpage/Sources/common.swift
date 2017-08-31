import Foundation
import CoreGraphics

//范围缩小

public protocol Smaller {
    func smaller() -> Self?
}

extension Int:Smaller {
    public func smaller() -> Int? {
        return self == 0 ? nil : self / 2
    }
}

extension String:Smaller {
    public func smaller() -> String? {
        return isEmpty ? nil : String.init(characters.dropFirst())
    }
}
//定义一个只返回自身实例的协议方法
public protocol Arbitrary : Smaller{
    static func arbitrary() -> Self
}

//Int 随机数
extension Int:Arbitrary {
    public static func arbitrary() -> Int {
        return Int(arc4random())
    }
    
    public static func random(from:Int,to:Int) -> Int {
        return from + (Int(arc4random()) % Int(to - from))
    }
}

//Character
extension Character:Arbitrary {
    public func smaller() -> Character? {
        return nil
    }

    public static func arbitrary() -> Character {
//        return Character.init("A")
        return Character(UnicodeScalar.init(Int.random(from:65,to:90))!)
    }
}

//CGFloat
extension CGFloat:Arbitrary {
    public func smaller() -> CGFloat? {
        return nil
    }

    public static func arbitrary() -> CGFloat {
        let num = CGFloat(UInt32.max) * CGFloat(Float(arc4random()) / Float(UInt32.max))
        let pre = (arc4random() % 2 == 0) ? 1 : -1
        return  CGFloat(pre) * num
    }
}

public func tabulate<A>(times:Int,transform: (Int) -> A) -> [A] {
    return (0..<times).map(transform)
}

//随机生成长度为 0- 40 之间的 大写字符串
extension String:Arbitrary {
    public static func arbitrary() -> String {
        let randomLength = Int.random(from: 0, to: 40)
        let randomCharacters = tabulate(times: randomLength) { (_) -> Character in
            return Character.arbitrary()
        }
        return String.init(randomCharacters)
    }
}



extension Array where Element : Arbitrary {
    public static func arbitrary() -> Array<Element> {
        let randomLength = Int(arc4random() % 50)
        return tabulate(times: randomLength, transform: {_ in Element.arbitrary()})
    }
}

extension Array:Smaller {
    public func smaller() -> Array<Element>? {
        guard isEmpty else { return nil}
        return Array.init(self.dropFirst())
    }
}



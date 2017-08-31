//: [Previous](@previous)

import Foundation
import CoreGraphics

var str = "Hello, playground"
let numberOfIterations = 100
//: [Next](@next)

/*:
 为了构建 Swift 版本的 QuickCheck，我们需要做⼏件事情：
 * ⾸先，我们需要⼀个⽅法来⽣成不同类型的随机数。
 * 有了随机数⽣成器之后，我们需要实现 check 函数，然后将随机数传递给它的特性参数。
 * 如果⼀个测试失败了，我们会希望测试的输⼊值尽可能⼩。⽐⽅说，如果我们在对⼀个
 有 100 个元素的数组进⾏测试时失败了，我们会尝试让数组元素更少⼀些，然后看⼀看
 测试是否依然失败。
 * 最后，我们还需要做⼀些额外的⼯作以确保检验函数适⽤于带有泛型的类型。
 */


// 随机整数
let m = Int.arbitrary()
//随机字符串
let s = String.arbitrary()

let f = CGFloat.arbitrary()

//1:
func check1<A:Arbitrary>(message:String,_ property:(A)->Bool) {
    
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            print("\"\(message)\" dosen't hold: \(value)")
            return
        }
    }
    print (" \"\(message)\" passed \(numberOfIterations) tests.")
}

extension CGSize:Arbitrary {
    var area : CGFloat {
        return width * height
    }
    public func smaller() -> CGSize? {
        return nil
    }
    public static func arbitrary() -> CGSize {
        return CGSize.init(width: CGFloat.arbitrary(), height: CGFloat.arbitrary())
    }
}

check1(message: "Area >= 0") { (size:CGSize) -> Bool in
    size.area >= 0
}


//2:
func iterateWhile<A>(condition:(A)->Bool,inital:A,next:(A)->A?) -> A {
    if let x = next(inital) , condition(x) {
        return iterateWhile(condition: condition, inital: x, next: next)
    }
    return inital
}

func check2<A:Arbitrary>(message:String,_ property:(A)->Bool) {
    
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            let smallValue = iterateWhile(condition: { (a) -> Bool in
                return !property(a)
            }, inital: value, next: { (a) -> A? in
                return a.smaller()
            })
            print("\"\(message)\" dosen't hold: \(smallValue)")
            return
        }
    }
    print (" \"\(message)\" passed \(numberOfIterations) tests.")
}

check2(message: "has prefix") { (s:String) -> Bool in
    s.hasPrefix("WIND")
}


//快排
struct ArbitraryInstance<T> {
    let arbitrary : ()->T
    let smaller : (T) -> T?
}

func checkHelper<A>(instance:ArbitraryInstance<A>,message:String,_ property:(A) -> Bool) {
    for _ in 0..<numberOfIterations {
        let value = instance.arbitrary()
        guard property(value) else {
            let smallValue = iterateWhile(condition: { (a:A) -> Bool in
                return !property(a)
            }, inital: value, next: instance.smaller)
            
            print("\"\(message)\" dosen't hold: \(smallValue)")
            return
        }
    }
    print (" \"\(message)\" passed \(numberOfIterations) tests.")
}


func check<X:Arbitrary>(message:String,_ property:([X]) -> Bool) {
    let instance = ArbitraryInstance.init(arbitrary: { () -> [X] in
        return [X].arbitrary()
    }) { (x:[X]) -> [X]? in
        return x.smaller()
    }
    checkHelper(instance: instance, message: message, property)
}


func qsort(_ array: [Int]) -> [Int] {
    if array.isEmpty { return [] }
    var temp = array
    let pivot = temp.remove(at: 0)
    let lesser = temp.filter { $0 < pivot }
    let greater = temp.filter { $0 >= pivot }
    var result = qsort(lesser)
    result.append(pivot)
    result.append(contentsOf: qsort(greater))
    return result
}
check(message: "kuaipai") { (x:[Int]) -> Bool in
    return qsort(x) == x.sorted(by: >)
}

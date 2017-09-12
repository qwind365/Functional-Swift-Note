import Foundation

public struct IteratorTest : IteratorProtocol {
    public typealias Element = Int
    
    var count : Int
    
    public init<T>(arr : [T]) {
        self.count = arr.count
    }
    
    public mutating func next() -> Int? {
        count -= 1
        return count >= 0 ? count : nil
    }
}

public struct ReverseSequence<T>:Sequence {
    public typealias Iterator = IteratorTest
    
    var arr: [T]
    
    public init(array:[T]) {
        self.arr = array
    }
    
    public func makeIterator() -> IteratorTest {
        return IteratorTest.init(arr: arr)
    }
}

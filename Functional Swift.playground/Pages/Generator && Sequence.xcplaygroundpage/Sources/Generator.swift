import Foundation

protocol GeneratorType {
    associatedtype Element
    func next() -> Element?
}

public class CountdownGenerator: GeneratorType {
    typealias Element = Int
    
    var element : Int = 0
    
    public init<T>(array:[T]) {
        self.element = array.count
    }
    
    public func next() -> Int? {
        self.element -= 1
        return self.element >= 0 ? self.element : nil
    }
}
public class PowerGenerator:GeneratorType {
    
    typealias Element = NSDecimalNumber
    
    var power:NSDecimalNumber = 1
    var two : NSDecimalNumber = 2
    
    public init() {};

    public func next() -> NSDecimalNumber? {
        power = power.multiplying(by: two)
        return power
    }
    
    public func findPower(predicate:(NSDecimalNumber) -> Bool) -> NSDecimalNumber {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return 0
    }
}

public class AnyGeneratorTest<T> : GeneratorType {
    typealias Element = T
    
    var nextBlock : () -> T?
    
    public init(next: @escaping () -> T?) {
        self.nextBlock = next
    }
    
    public func next() -> T? {
        return self.nextBlock()
    }
    
}



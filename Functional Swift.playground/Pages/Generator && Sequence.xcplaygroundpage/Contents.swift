//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)


let arr = ["A","B","C"]
let generator = CountdownGenerator.init(array: arr)
while let i = generator.next() {
    print("Element \(i) of the array is \(arr[i])")
}

let power = PowerGenerator().findPower { $0.intValue > 1000}
print("\(power.intValue)")


extension Int {
    func countDown() -> AnyGeneratorTest<Int> {
        var i = self
        return AnyGeneratorTest.init(next: { () -> Int? in
            i -= 1
            return i >= 0 ? i : nil
        })
    }
}

let generator2 = 5.countDown()
while let i = generator2.next() {
    print("test \(i)")
}



/*
 *    Sequence
 **/

let reverse = ReverseSequence.init(array: arr)
var iterator = reverse.makeIterator()
while let i = iterator.next() {
    print("Index \(i) is \(arr[i])")
}

for i in reverse {
    print("Index \(i) is \(arr[i])")
}
for item in reverse.map({arr[$0]}) {
    print("result \(item)")
}
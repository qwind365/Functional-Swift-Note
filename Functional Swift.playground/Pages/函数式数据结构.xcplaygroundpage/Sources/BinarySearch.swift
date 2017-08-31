import Foundation

public indirect enum BinarySearchTree<Element:Comparable> {
    case Leaf
    case Node(BinarySearchTree<Element>,Element,BinarySearchTree<Element>)
    public init() {
        self = .Leaf
    }
    
    public init(_ value:Element) {
        self = .Node(.Leaf,value,.Leaf)
    }
}

//count

extension BinarySearchTree {
    public var count:Int {
        switch self {
        case .Leaf:
            return 0
        case let .Node(left,_,right):
            return 1 + left.count + right.count
        }
    }
}

//elements
extension BinarySearchTree {
    public var elements:[Element] {
        switch self {
        case .Leaf:
            return []
        case let .Node(left,element,right):
            return left.elements + [element] + right.elements
        }
    }
}

//isEmpty
extension BinarySearchTree {
    public var isEmpty:Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
}

extension Sequence {
    public func all(_ predicate: (Self.Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
}

//isBST
extension BinarySearchTree where Element:Comparable {
    public var isBST:Bool {
        switch self {
        case .Leaf:
            return true
        case let .Node(left,x,right):
            return left.elements.all({ (y) -> Bool in
                return y <= x
            }) && right.elements.all({ (y) -> Bool in
                return y >= x
            }) && left.isBST && right.isBST
        }
    }
}

//contains

extension BinarySearchTree {
    public func contains(x:Element) -> Bool {
        switch self {
        case .Leaf:
            return false
        case let .Node(_,y,_) where x == y:
            return true
        case let .Node(left,y,_) where x < y :
            return left.contains(x: x)
        case let .Node(_,y,right) where x > y :
            return right.contains(x: x)
        default:
            fatalError("error")
        }
    }
}

// insert

extension BinarySearchTree {
    public mutating func insert(x:Element) {
        switch self {
        case .Leaf:
            self = BinarySearchTree.init(x)
        case let .Node(left, y,right):
            var templ = left
            var tempr = right
            if x < y {
                templ.insert(x: x)
            }else {
                tempr.insert(x: x)
            }
            self = .Node(templ,y,tempr)
        }
    }
}

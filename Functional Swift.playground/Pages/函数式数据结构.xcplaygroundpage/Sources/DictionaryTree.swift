import Foundation

public struct Trie<Element:Hashable> {
    public let isElement:Bool
    public let children: [Element:Trie<Element>]
}

extension Trie {
    public init() {
        isElement = false
        children = [:]
    }
}
extension Trie {
    //此处[Element] 代表一个完整的连续元素
    public var elements:[[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key,value) in children {
            result += value.elements.map{ [key] + $0}
        }
        return result
    }
}

extension Array {
    public var decompose:(Element,[Element])? {
        return isEmpty ? nil : (self[startIndex],Array(self.dropFirst()))
    }
}

extension Trie {
    public func lookup(key:[Element]) -> Bool {
        guard let (head,tail) = key.decompose else {
            return isElement
        }
        guard let subtrie = children[head] else {
            return false
        }
        return subtrie.lookup(key: tail)
    }
}

extension Trie {
    public func withPrefix(prefix:[Element]) -> Trie<Element>? {
        guard let (head,tail) = prefix.decompose else {
            return self
        }
        guard let subtrie = children[head] else {
            return nil
        }
        return subtrie.withPrefix(prefix: tail)
    }
    
    public func autocomplete(key:[Element]) -> [[Element]] {
        return withPrefix(prefix: key)?.elements ?? []
    }
}


extension Trie {
    public init(_ key:[Element]) {
        if let (head,tail) = key.decompose {
            let children = [head:Trie(tail)]
            self = Trie(isElement: false, children: children)
        }else {
            self = Trie(isElement: true, children: [:])
        }
    }
}

extension Trie {
    public mutating func insert(key:[Element]) {
        guard let (head,tail) = key.decompose else {
            self = Trie(isElement: true, children: children)
            return
        }
        var newChilds = children
        if var nextTrie = newChilds[head] {
            nextTrie.insert(key: tail)
            newChilds[head] = nextTrie
        }else {
            newChilds[head] = Trie.init(tail)
        }
        self = Trie(isElement: isElement, children: newChilds)
    }
}

//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

//二叉搜索
let tests = [1,3,7,2,3,45,2,4,6,23,34,6,9,64,546,6778,99,2,34,56,4,786]

var myTree:BinarySearchTree<Int> = BinarySearchTree()
let isEmpty = myTree.isEmpty

for item in tests {
    myTree.insert(x: item)
}

let isBST = myTree.isBST
let elements = myTree.elements
let count = myTree.count
let isHas = myTree.contains(x: 99)
let isHas2 = myTree.contains(x: 9999)


//基于字典树的自动补全

//求和
func sum(nums:[Int]) -> Int {
    guard let (head,tail) = nums.decompose else {
        return 0
    }
    return head + sum(nums: tail)
}

let hah = sum(nums: tests)

//快排
func qsort(input:[Int]) -> [Int] {
    guard let (head,rest) = input.decompose else {
        return []
    }
    let great = rest.filter{$0 > head}
    let less = rest.filter{$0 <= head}
    let left = qsort(input: great)
    let right = qsort(input: less)
    return left + [head] + right
}

let sort = qsort(input: tests)

//字符串字典树
func buildStringTrie(words:[String]) -> Trie<Character> {
    var trie = Trie<Character>.init()
    for word in words {
        trie.insert(key: Array(word.characters))
    }
    return trie
}



func autocompleteString(knowWords:Trie<Character>,word:String) -> [String] {
    let chars = Array(word.characters)
    let completed = knowWords.autocomplete(key: chars)
    return completed.map({ (chars) in
        word + String.init(chars)
    })
}

let testStr = ["cat","car","hello","honey","dog","love","live","long","done","honor","hehe"]
let strTrie = buildStringTrie(words: testStr)

let result = autocompleteString(knowWords: strTrie, word: "c")









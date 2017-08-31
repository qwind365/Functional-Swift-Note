//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: 把处理确定类型的函数定义为该类型的扩展


//定义学生 有一个名字还有分数
struct Student {
    let name:String
    let score:Int
}


let ming = Student.init(name: "小明", score: 68)
let hong = Student.init(name: "小红", score: 96)
let san = Student.init(name: "张三", score: 45)
let si = Student.init(name: "李四", score: 86)

let students = [ming, hong, san, si]

//如果分数及格(>60)，每一分奖励100元，现在打印一份取得奖励的同学以及奖励数额



let result = students.filter {$0.score > 60}.map {
    stu in return
    Student.init(name: stu.name, score: stu.score * 100)
}.reduce("Result:\nName: Award") { (result, stu) in
    return result + "\n" + "\(stu.name): " + "\(stu.score)"
}

print(result)


//泛型应用
func curry<A,B,C>(f: @escaping (A) -> B , g: @escaping (B) -> C) -> (A) -> C {
    return {x in g(f(x))}
}




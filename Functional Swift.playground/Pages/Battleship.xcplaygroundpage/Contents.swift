//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*:
 ### 案例：Battleship
 一艘战舰的射程范围有最大值和最小值（超出最大值打不到，小于最小值射击不安全），现在要判断某一位置的地方战舰是否在射程范围内，同时要避免射击到友方战舰的安全范围内。
 
 结构体`Ship`中实现了两种设计的方法：`canFireShip`和`canFireShip2`. 具体代码请看 [Battleship.swift](/Sources/Battleship.swift)
 */


/*:
 这个例子就是将函数作为参数进而来构造更大规模的程序最终实现需求的设计方式。上面例子的关键 就在于`(Position) -> Bool`类型的定义，在函数式编程过程中我们要谨慎选择类型，让类型来驱动开发。
 */
let ship = Ship(location: Position(x: 10, y: 10), fireMaxRange: 30, fireMinRange: 10)
let friend = Ship(location: Position(x: 30, y: 30), fireMaxRange: 30, fireMinRange: 10)
let target = Ship(location: Position(x: 20, y: 20), fireMaxRange: 30, fireMinRange: 10)

let result = ship.canFireShip(target: target, friend: friend)
let result2 = ship.canFireShip2(target: target, friend: friend)



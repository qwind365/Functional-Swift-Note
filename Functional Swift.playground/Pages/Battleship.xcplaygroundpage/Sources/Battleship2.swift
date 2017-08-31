import Foundation
//print("load....")
///声明表示距离的类型
public typealias Distance = Double

/// 构造一个位置结构体
public struct Position {
    public var x: Double
    public var y: Double
    public init(x:Double,y:Double) {
        self.x = x
        self.y = y
    }
}

extension Position {
    func inRange(range:Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
    func minus( p:Position ) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var length:Double {
        return sqrt(x * x + y * y)
    }
}



/// 定义有一个位置信息的到能否开火的函数类型
typealias Region = (Position) -> Bool

func circle(radius:Distance) -> Region {
    return {point in point.length <= radius}
}


func shift(region:@escaping Region, offset:Position) -> Region {
    return {point in region(point.minus(p: offset))}
}

func invert(region:@escaping Region) -> Region {
    return {point in !region(point)}
}

func intersection(region1:@escaping Region,region2:@escaping Region) -> Region {
    return {point in region1(point) && region2(point)}
}

func union(region1:@escaping Region,region2:@escaping Region) -> Region {
    return {point in region1(point) || region2(point)}
}

func difference(region:@escaping Region, minusRegion:@escaping Region) -> Region {
    return intersection(region1: region, region2: invert(region: minusRegion))
}



/// 构造一个战舰
public struct Ship {
    
    /// 战舰中心点
    public var location:Position
    
    /// 最远射程
    public var fireMaxRange:Distance
    
    /// 最近的安全射程
    public var fireMinRange:Distance
    
    public func canFireShip(target:Ship,friend:Ship) -> Bool {
        let rangeRegion = difference(region: circle(radius: fireMaxRange), minusRegion: circle(radius: fireMinRange))
        let friendRegion = shift(region: circle(radius: friend.fireMinRange), offset: friend.location)
        
        let haha = shift(region: rangeRegion, offset: location)
        
        let result = difference(region: haha, minusRegion: friendRegion)
        
        return result(target.location)
    }
    
    public init(location:Position,fireMaxRange:Distance,fireMinRange:Distance) {
        self.location = location
        self.fireMaxRange = fireMaxRange
        self.fireMinRange = fireMinRange
    }
}


/*:
 ##第二种实现  代码阅读起来更优雅
 */


struct Region2 {
    let lookup: (Position) -> Bool
    
    static func circle(radius:Distance) -> Region2 {
        return Region2.init(lookup: {point in point.length <= radius})
    }
    
    
    func shift(offset:Position) -> Region2 {
        return Region2.init(lookup: {point in self.lookup(point.minus(p: offset))})
    }
    
    func invert() -> Region2 {
        return Region2.init(lookup: {point in !self.lookup(point)})
    }
    
    func intersection(region: Region2) -> Region2 {
        return Region2.init(lookup: {point in self.lookup(point) && region.lookup(point)})
    }
    
    func union(region: Region2) -> Region2 {
        return Region2.init(lookup: {point in self.lookup(point) || region.lookup(point)})
    }
    
    func difference(region: Region2) -> Region2 {
        return self.intersection(region: region.invert())
    }

}

extension Ship {
    public func canFireShip2(target:Ship,friend:Ship) -> Bool {
        
        let rangeRegion = Region2.circle(radius: fireMaxRange).difference(region: Region2.circle(radius: fireMinRange))
        let friendRegion = Region2.circle(radius: friend.fireMinRange).shift(offset: friend.location)
        let result = rangeRegion.shift(offset: location).difference(region: friendRegion)
        
        let canFire = result.lookup(target.location)
        return canFire
    }
}


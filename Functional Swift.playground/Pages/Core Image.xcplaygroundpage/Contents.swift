//: [Previous](@previous)

import Foundation
import CoreImage
import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
var str = "Hello, playground"

//构建滤镜类型， 由一个CIImage对象经过操作输出另一个CIImage对象
typealias Filter = (CIImage) -> CIImage

///构建常见的一些滤镜

///模糊
func blur(radius:Double) -> Filter {
    return {
        image in
        let params = [kCIInputRadiusKey:radius,
                      kCIInputImageKey:image] as [String : Any]
        guard let filter = CIFilter.init(name: "CIGaussianBlur", withInputParameters: params) else {
            fatalError()
        }
        guard let outputImage = filter.outputImage else     {
            fatalError()
        }
        return outputImage
    }
}

///颜色叠层
func colorGenerator(color:UIColor) -> Filter {
    return {
        image in
        
        let params = [kCIInputColorKey:color] as [String:Any]
        guard let filter = CIFilter.init(name: "CIConstantColorGenerator", withInputParameters: params) else {
            fatalError()
        }
        
        guard let outputImage = filter.outputImage else     {
            fatalError()
        }
        return outputImage.cropping(to: image.extent)
    }
}

//合成
func compositeSourceOver(overlay:CIImage) -> Filter {
    return {
        image in
        let params = [kCIInputBackgroundImageKey:image,
                      kCIInputImageKey:overlay] as [String:Any]
        guard let filter = CIFilter.init(name: "CISourceOverCompositing", withInputParameters: params) else {
            fatalError()
        }
        
        guard let outputImage = filter.outputImage else     {
            fatalError()
        }
        
        return outputImage.cropping(to: image.extent)
    }
}

func colorOverlay(color:UIColor) -> Filter {
    return {
        image in
        let overlay = colorOverlay(color: color)(image)
        return compositeSourceOver(overlay: overlay)(image)
    }
}


///组合滤镜(先模糊然后添加颜色叠层)

precedencegroup FilterNext {
    associativity : left
}

infix operator >>> : FilterNext
func >>>(_ filter1: @escaping Filter,_ filter2: @escaping Filter) -> Filter {
    return {image in filter2(filter1(image))
    }
}

//结果测试：

let image = CIImage.init(contentsOf: URL.init(string: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1503042256&di=b831ed463b47bda8b02baaa023a32ad0&src=http://upload.subaonet.com/2011/0820/1313826147228.jpg")!)!


/*:
 生成颜色层滤镜方法`colorGenerator`调用失败，已提交issue
 */

let myFilter = blur(radius: 5.0)
let myfiler = colorGenerator(color: .red)
//let myFilter = colorOverlay(color: UIColor.red.withAlphaComponent(0.2))
//let myFilter = blur(radius: 5.0) >>> colorOverlay(color: UIColor.red)

let resultImg = myfiler(image)

let displayView = UIImageView.init(image: UIImage.init(ciImage: resultImg))
PlaygroundPage.current.liveView = displayView


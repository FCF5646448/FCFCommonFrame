//: Playground - noun: a place where people can play

import UIKit
var title = "内存管理：weak、unowned"
class A {
    var name:String
    var block:((_ name:String)->String)!
    init(name:String) {
        self.name = name
        print("A初始化")
    }
    func test()->String{
        let str = self.block(self.name)
        return str
    }
    deinit { print("A析构掉") }
}
class B {
    var a:A?
    var n:String = "fan"
    init() {
        print("B初始化")
    }
    func test(){
        a?.block = {[weak self] (name) -> String in //
            print(name)
            if let strongself = self {
                return strongself.n
            }
            return "no"
        }
    }
    deinit { print("B析构掉") }
}

var a:A? = A(name:"feng")
var b:B? = B()
b!.a = a
b!.test()
var str:String = a!.test()
print(str)

b = nil

class C{
    var name:String
    lazy var block:()->() = {[weak self] in
        if let strongSelf = self{
            print(strongSelf.name)
            print("self不为nil")
        }
        print("block")
    }
    init(name:String) {
        self.name = name
        print("C初始化")
    }
    deinit {
        print("C析构")
    }
}

class D{
    var block:(()->())!
    init(callBack:(()->())?) {
        self.block = callBack!
        print("D构造")
    }
    deinit {
        print("D析构")
    }
}

var c:C? = C(name:"c")
var d = D.init(callBack:c?.block)
c!.block()
c = nil
d.block()







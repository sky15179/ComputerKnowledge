//
//  ViewController.swift
//  learn-designPatterns
//
//  Created by 王智刚 on 2018/2/26.
//  Copyright © 2018年 王智刚. All rights reserved.
//

import UIKit

//面向对象的三个特征: 封装,继承,多态

//SOLID面向对象的五大原则:
//1. 单一职责原则:单一类应该只负责单一职责功能,不能包含五花八门的职责功能,封装
protocol CanOpen {
    func open()
}

protocol CanClose {
    func close()
}

class PanPanDoor: CanOpen, CanClose {
    var state: State = .closed
    
    enum State {
        case opened
        case closed
    }
    
    func open() {
        state = .opened
    }
    
    func close() {
        state = .closed
    }
}

class DoorOpener {
    let door: CanOpen
    init(door: CanOpen) {
        self.door = door
    }
    
    func excute() {
        door.open()
    }
}

class DoorCloser {
    let door: CanClose
    init(door: CanClose) {
        self.door = door
    }
    
    func excute() {
        door.close()
    }
}

//2. 开闭原则:一个模块在更改性方面应该是封闭的,在拓展性方面是开放的
protocol CanShoot {
    func shoot() -> String
}

class LaserBaem: CanShoot {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

final class WeaponsComposite {
    let weapons: [CanShoot]
    init(weapons: [CanShoot]) {
        self.weapons = weapons
    }
    func shoot() -> [String] {
        return self.weapons.map { $0.shoot() }
    }
}

final class Rocket: CanShoot {
    func shoot() -> String {
        return "Whooooo"
    }
}

//3. 里氏替换原则: 使用子类的地方可以替换成父类使用,多态

final class RequestError: NSError {
}

func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError) {
    return (nil, RequestError(domain: "DOMAIN", code: 0, userInfo: ["key": request]))
}

func willReturnObjectOrError() -> (Any?, NSError) {
    let result = fetchData(request: NSURLRequest())
    return (result.data, result.error)
}

//4. 依赖倒置: 面向抽象接口编程,自下而上设计,避免下层改动导致上层变化,从而引起不必要的影响
protocol TimeTravelAbale {
    func travelInTime(time: TimeInterval) -> String
}

final class Delozan: TimeTravelAbale {
    func travelInTime(time: TimeInterval) -> String {
        return "delozon travel in \(time)"
    }
}

final class EmmteBrown {
    private let timeMachine: TimeTravelAbale
    
    init(timeMachine: TimeTravelAbale) {
        self.timeMachine = timeMachine
    }
    
    func travelInTime(time: TimeInterval) -> String {
        return timeMachine.travelInTime(time:time)
    }
}

//5. 接口隔离: 模块之间通过抽象接口连接隔离耦合,避免对具体类强耦合,通过多个小的接口分割过大的接口
protocol SayHiAble {
    var hello: String { get }
}

protocol LearnAble {
    func learn(age: AgeAble) -> String
}

protocol AgeAble {
    var age: Int { get }
}

final class PrimaryStudent: AgeAble {
    let age = 6
}

final class MiddleStudent: AgeAble {
    let age = 12
}

final class School: LearnAble, SayHiAble {
    let hello = "你好"
    func learn(age: AgeAble) -> String {
        return "\(age.age)"
    }
}

//GOF设计模式的纲领: 面向对象的设计领域已有解决问题的方式总结
//1.根据"名称-问题-解决方案-效果"的模式来解决实际问题
//2.面向接口编程, 组合优于继承
//3.只针对已有问题的解决方式的总结

//Creation Patterns: 处理对象的创建
//1. 模板对象模式(Object Template Pattern): 使用对象封装细节,使用的时候直接使用对象
//苹果的实际使用: string, array, dictionary
class Car {
    enum type {
        case suv
        case bussiness
        case sport
    }
    
    let color: UIColor
    let name: String
    let age: Int
    
    init(color: UIColor, name: String, age: Int) {
        self.color = color
        self.name = name
        self.age = age
    }
}

let car1 = Car(color: UIColor.black, name: "1", age: 1)
let car2 = Car(color: UIColor.black, name: "2", age: 2)
let car3 = Car(color: UIColor.black, name: "3", age: 3)

//2. 原型模式(Prototype Pattern): 拷贝原型创造新的对象,避免重复创建
struct Appointment {
    let name: String
    let place: String
    var desc: String
}

//3.工厂模式:封装创造实例的地方
protocol CarAble {
    func run()
    func maxSpeed() -> Int
}

final class Benze: CarAble {
    func run() {
        print("benze go")
    }
    
    func maxSpeed() -> Int {
        return 100
    }
}

final class Baoma: CarAble {
    func run() {
        print("benze go")
    }
    
    func maxSpeed() -> Int {
        return 200
    }
}

final class Audio: CarAble {
    func run() {
        print("Audio go")
    }
    
    func maxSpeed() -> Int {
        return 300
    }
}

final class CarFactory {
    enum CarType {
        case benze, baoma, audio
    }
    
    func creat(type: CarType) -> CarAble {
        switch type {
        case .benze:
            return Benze()
        case .baoma:
            return Baoma()
        case .audio:
            return Audio()
        }
    }
}

//4.抽象工厂模式:创建工厂的工厂,注意抽象工厂和工厂相比专注的能力不同
protocol DecimalAble {
    func stringValue() -> String
    
    //factory
    static func make(string: String) -> DecimalAble
}

struct NSDecimal: DecimalAble {
    private var nextStepNumber: NSNumber
    func stringValue() -> String {
        return "\(nextStepNumber.stringValue)"
    }
    
    static func make(string: String) -> DecimalAble {
        return NSDecimal(nextStepNumber: NSNumber(value: (string as NSString).doubleValue))
    }
}

struct swiftDecimalAble: DecimalAble {
    private var nextStepNumber: Int
    func stringValue() -> String {
        return "\(nextStepNumber)"
    }
    
    static func make(string: String) -> DecimalAble {
        return swiftDecimalAble(nextStepNumber: Int((string as NSString).intValue))
    }
}

typealias NumberFactory = (String) -> DecimalAble

class NumberHelper {
    enum NumberType {
        case ns, swift
    }
    static func factory(type: NumberType) -> NumberFactory {
        switch type {
        case .ns:
            return NSDecimal.make
        case .swift:
            return swiftDecimalAble.make
        }
    }
}

//5.生产者模式:当模块的初始化参数过多,解决构造过程太复杂,通过一个辅助类来构造类
//苹果中的应用:NSDateComponents
class StarBuilder {
    var x: Int?
    var y: Int?
    var z: Int?
    var weight: Double?
    var volume: Double?
    
    typealias BuilderClosure = (StarBuilder)->()
    
    init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
}

class Star {
    let x: Int
    let y: Int
    let z: Int
    
    init?(builder: StarBuilder) {
        guard let x = builder.x, let y = builder.y, let z = builder.z else {
            return nil
        }
        self.x = x
        self.y = y
        self.z = z
    }
}

//6.单例模式: 单例的几种实现方式,单例和线程,单例和全局变量
//单例的实现方式:饿汉,类初始化就创建了单例,类只会load一次,也就是线程安全的
class Ship {
    static let shareInstance = Ship()
    private init(){
    }
}
//懒汉,第一次调用的时候实例化,非线程安全,需要锁
class Ship2 {
    private static var instance: Ship2?
    static func shareInstance() -> Ship2 {
        guard let rinstance = instance else {
            objc_sync_enter(self)
            instance = Ship2()
            objc_sync_exit(self)
            return instance!
        }
        return rinstance
    }
    private init(){
    }
}
//7.对象池模式:避免昂贵的重复对象创建,多用在线程操作和网络请求方面
/**对象池的设计到线程安全和竞态的处理,还有边界情况,关于池的设计主要考虑:
 1.池中对象的创建
 2.池中对象的重用
 3.池的清空
 4.池中对象的销毁
 **/
//实际应用: UITableCell

//StructPatterns结构模式: 处理对象的组合使用以及拓展,模块解耦
//1.适配器模式 Adapter: 拓展已有对象api接口,在不更改原有api的状态下拓展能力

protocol VedioAble {
    func play()
    func pause()
    func stop()
}

class OldVedio {
    func oldPlay() {
        print("old play")
    }
    
    func oldPause() {
        print("old pause")
    }
    
    func oldStop() {
        print("old stop")
    }
}

class NewVedio: VedioAble {
    func play() {
        print("new play")
    }
    
    func pause() {
        print("new pause")
    }
    
    func stop() {
        print("new stop")
    }
}

class VedioAadpter: VedioAble {
    private let target: OldVedio
    
    init(target: OldVedio) {
        self.target = target
    }
    
    func play() {
        self.target.oldPlay()
    }
    
    func pause() {
        self.target.oldPause()
    }
    
    func stop() {
        self.target.oldStop()
    }
}

//2.外观模式 Facade Pattern: 保持原有模块api不变,封装代码,在底层和应用层之间提供一层高度封装的接口,实现拓展
//实际应用: 自己实现的各种便捷类,UITextView
class eternal {
    static func set(object: Any, for key: String) {
        let store = UserDefaults.standard
        store.set(object, forKey: key)
        _ = store.synchronize()
    }
    
    static func object(for key: String) -> AnyObject! {
        let store = UserDefaults.standard
        return store.object(forKey: key) as AnyObject
    }
}
//3.装饰器模式 Decorator Pattern: 保持原有模块接口不变,通过装饰器修改单个对象的行为
//实际应用: NSClipView
protocol CoffeeAble {
    func getCost() -> Int
    func getIngredients() -> String
}

class SimpleCoffee: CoffeeAble {
    func getCost() -> Int {
        return 2
    }
    
    func getIngredients() -> String {
        return "coffe bean"
    }
}

class CoffeeDecorator: CoffeeAble {
    private let decoratedCoffee: CoffeeAble
    fileprivate let decoratedCoffeeSeparator = ","
    
    required init(coffee: CoffeeAble) {
        self.decoratedCoffee = coffee
    }
    
    func getCost() -> Int {
        return decoratedCoffee.getCost()
    }
    
    func getIngredients() -> String {
        return decoratedCoffee.getIngredients()
    }
}

final class Milk: CoffeeDecorator {
    required init(coffee: CoffeeAble) {
        super.init(coffee: coffee)
    }
    
    override func getCost() -> Int {
        return super.getCost() + 1
    }
    
    override func getIngredients() -> String {
        return super.getIngredients() + decoratedCoffeeSeparator + "milk"
    }
}

final class WhipCoffee: CoffeeDecorator {
    required init(coffee: CoffeeAble) {
        super.init(coffee: coffee)
    }
    
    override func getCost() -> Int {
        return super.getCost() + 2
    }
    
    override func getIngredients() -> String {
        return super.getIngredients() + decoratedCoffeeSeparator + "whip"
    }
}

//4.复合模式 Compsite Pattern: 处理继承,递归的树状结构,对单一对象和复合都保持一致的访问接口
//实际应用:UIView
protocol Shape {
    func draw(fillColor: String)
}

class Circle: Shape {
    func draw(fillColor: String) {
        print("drawing a circle with \(fillColor)")
    }
}

class Square: Shape {
    func draw(fillColor: String) {
        print("drawing a square with \(fillColor)")
    }
}

class WhiteBoard: Shape {
    let shapes: [Shape]
    required init(shapes: [Shape]) {
        self.shapes = shapes
    }
    func draw(fillColor: String) {
        for shape in shapes {
            shape.draw(fillColor: fillColor)
        }
    }
}

//5.代理模式 Proxy Pattern: 为其他对象提供一种代理(中间层aop)的方式访问原对象,可以有一些hook和追踪的操作
//实际应用:NSProxy
//保护代理: 能够限制对真正对象的一些访问
protocol DoorOperator {
    func open(doors: String) -> String
}

class HAL900: DoorOperator {
    func open(doors: String) -> String {
        return "the door \(doors) have opened"
    }
}

class CurrentProxy: DoorOperator {
    private var machine: HAL900?
    
    func open(doors: String) -> String {
        guard machine != nil else {
            return "can not do that, enter pass word first"
        }
        guard let result = machine?.open(doors:doors) else { return "wrong" }
        return result
    }
    
    func authenticate(with password: String) -> Bool {
        guard password == "pass" else {
            return false
        }
        machine = HAL900()
        return true
    }
}

//虚拟代理:machine在CurrentProxy是lazy加载的

//6.桥模式 Bridge Pattern: 分离抽象和实现,两个平台之间通过桥联系,通过桥来将依赖注入到实现类中,桥作为一个关联层存在,在不改变原有抽象接口的前提下替换实现细节
protocol Appliance {
    func run()
}

protocol Switch {
    func turnOn()
    var appliance: Appliance { get set }
}

class RemoteControl: Switch {
    var appliance: Appliance
    init(appliance: Appliance) {
        self.appliance = appliance
    }
    
    func turnOn() {
        self.appliance.run()
    }
}

final class TV: Appliance {
    func run() {
        print("TV run")
    }
}

final class VacuumCleaner: Appliance {
    func run() {
        print("VacuumCleaner run")
    }
}

//7.享元模式 FlyWeight Pattern: 最小化使用内存,工厂类中通过map缓存对象,只在无缓存的时候才创建新的对象

final class Menu {
    private var coffees: [String: SimpleCoffee] = [:]
    func lookup(name: String) -> SimpleCoffee {
        guard let coffee = coffees[name] else {
            let newCoffee = SimpleCoffee()
            coffees[name] = newCoffee
            return newCoffee
        }
        return coffee
    }
}

final class CoffeeShop {
    private let menu = Menu()
    private var orders: [Int: SimpleCoffee] = [:]
    func getOrder(name: String, table: Int) {
        let coffee = menu.lookup(name: name)
        orders[table] = coffee
    }
    
}
//BehaviorPatterns行为模式: 处理对象之间的通信,层级解耦
//1.观察者模式 Observer Pattern: 处理一对多的依赖关系,实现都是在观察类里有一个arraylist记录被观察的对象,当状态发生改变,推送更新给所有的观察者,需要考虑线程交互的问题
//实际应用: KVO

protocol Observer: class {
    func willChange(name: String, newValue: Any?)
    func didChange(name: String, oldValue: Any?)
}

class NameObserver: Observer {
    func willChange(name: String, newValue: Any?) {
        if name == "name", newValue as? String == "111" {
            print("结果准备改变")
        }
    }
    
    func didChange(name: String, oldValue: Any?) {
        if name == "name", oldValue as? String == "222" {
            print("结果已经改变")
        }
    }
}

class Wind {
    var max: Int
    var mix: Int
    var name: String {
        willSet {
            self.observer?.willChange(name: "name", newValue: newValue)
        }
        didSet {
            self.observer?.didChange(name: "name", oldValue: oldValue)
        }
    }
    weak var observer: Observer?
    init(max: Int, mix: Int, name: String) {
        self.max = max
        self.mix = mix
        self.name = name
    }
}

protocol ANotificationAble {
    func addObsever(observer: AnyObject, name: String, selector: Selector, object: AnyObject)
    func postNotificaiton(name: String, info: [String: Any], object: AnyObject)
    func removeObserver(name: String)
}

protocol AObserverAble {
    var name: String { get set }
    var selector: Selector { get set }
    var object: AnyObject { get set }
}

class AObserver: NSObject, AObserverAble {
    var name: String
    var selector: Selector
    var object: AnyObject
    
    init(name: String, sel: Selector, object: AnyObject) {
        self.name = name
        self.selector = sel
        self.object = object
    }
}

//kvc实现
class ANotificationCenter: ANotificationAble {
    
    static let defaultCenter = ANotificationCenter()
    private var notifyMap: [String: [AObserver]] = [:]
    private init() {
        
    }
    func removeObserver(name: String) {
        _ = self.notifyMap.removeValue(forKey: name)
    }
    
    func addObsever(observer: AnyObject, name: String, selector: Selector, object: AnyObject) {
        if let obsevers = notifyMap[name] {
            //更新数组
            notifyMap[name] = obsevers
        } else {
            let new = AObserver(name: name, sel: selector, object: object)
            notifyMap[name] = [new]
        }
    }
    
    func postNotificaiton(name: String, info: [String : Any], object: AnyObject) {
        notifyMap.forEach { (arg) in
            let (key, observes) = arg
            if key == name {
                observes.forEach { observer in
                    observer.perform(observer.selector, with: object)
                }
            }
        }
    }
}
//2.责任链模式 Chain of Responsibility Pattern: 多个对象处理同一个回调且对象之间是递归的关系时使用责任链,用来处理多种的请求有不同的处理对象
//实际应用: UIResponder
final class MoneyPile {
    var next: MoneyPile?
    let value: Int
    var quantity: Int
    
    init(value: Int, quantity: Int, next: MoneyPile?) {
        self.value = value
        self.quantity = quantity
        self.next = next
    }
    
    func canWithDraw(amount: Int) -> Bool {
        func canTakeSomeBill(want: Int) -> Bool {
            return (want/self.value) > 0
        }
        var amount = amount
        var quantity = self.quantity
        while canTakeSomeBill(want: amount) {
            if quantity == 0 {
                break
            }
            
            amount -= self.value
            quantity -= 1
        }
    
        guard amount > 0 else {
            return true
        }
        
        if let next = self.next {
            return next.canWithDraw(amount: amount)
        }
        
        return false
    }
}

final class ATM {
    private var hundred: MoneyPile
    private var fifty: MoneyPile
    private var twenty: MoneyPile
    private var ten: MoneyPile
    
    private var startPile: MoneyPile {
        return self.hundred
    }
    
    init(hundred: MoneyPile, fifty: MoneyPile, twenty: MoneyPile, ten: MoneyPile) {
        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }
    
    func canWithDraw(amount: Int) -> String {
        return "Can draw \(startPile.canWithDraw(amount: amount))"
    }
}

//3.模板方法模式 Template Pattern: 抽象通用算法,通过抽象类暴露出来,子类按需重写
//实际应用: viewdidload
protocol ICodeGenerator {
    func crossComplice()
}

protocol IGeneratorPhases {
    func collectSource()
    func crossComplice()
}

class CodeGenerator: ICodeGenerator {
    var delegate: IGeneratorPhases
    
    init(delegate: IGeneratorPhases) {
        self.delegate = delegate
    }
    
    private func fetchDataForGeneration() {
        print("fetch data invoke")
    }
    
    func crossComplice() {
        fetchDataForGeneration()
        delegate.collectSource()
        delegate.crossComplice()
    }
}

final class HTMLCodeGeneratorPhases: IGeneratorPhases {
    func collectSource() {
        print("HTML collectSource")
    }
    
    func crossComplice() {
        print("HTML crossComplice")
    }
}

final class JSONCodeGeneratorPhases: IGeneratorPhases {
    func collectSource() {
        print("JSON collectSource")
    }
    
    func crossComplice() {
        print("JSON crossComplice")
    }
}
//4.命令模式 Command: 封装一个请求和他的参数,接收者可以保存下来选择时机执行
//实际应用: NSInvocation
protocol DoorCommand {
    func excute() -> String
}

final class OpenDoorCommad: DoorCommand {
    let door: String
    init(door: String) {
        self.door = door
    }
    func excute() -> String {
        return "open the \(door)"
    }
}

final class CloseDoorCommand: DoorCommand {
    let door: String
    init(door: String) {
        self.door = door
    }
    func excute() -> String {
        return "close the \(door)"
    }
}

final class PanPan2DoorOperations {
    let openCommand: DoorCommand
    let closeCommand: DoorCommand
    
    init(door: String) {
        self.openCommand = OpenDoorCommad(door: door)
        self.closeCommand = CloseDoorCommand(door: door)
    }
    
    func open() {
        print(self.openCommand.excute())
    }
    
    func close() {
        print(self.closeCommand.excute())
    }
}
//5.中介者模式 Mediator Pattern: 对象之间存在大量的关联关系,通过中介者管理他们的关系松耦合
protocol Receiver {
    associatedtype MessageType
    func receive(message: MessageType)
}

protocol Sender {
    associatedtype MessageType
    associatedtype ReceiverType: Receiver
    func send(message: MessageType)
    var receivers: [ReceiverType] { get }
}

class Prorammer: Receiver {
    let name: String
    init(name: String) {
        self.name = name
    }
    func receive(message: String) {
        print("\(name) receive \(message)")
    }
}

class MessageMediator: Sender {
    var receivers: [Prorammer] = []
    func add(programmer: Prorammer)  {
        receivers.append(programmer)
    }
    func send(message: String) {
        receivers.forEach { $0.receive(message: message)}
    }
}
//6.策略模式 strategy pattern: 算法封装
//实际应用: NSComparisonResult
protocol PrintStrategy {
    func print(string: String) -> String
}

final class Pinter {
    private let strategy: PrintStrategy
    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
    
    func sprint(string: String) {
        print("\(strategy.print(string: string))")
    }
}

final class LowerStrategy: PrintStrategy {
    func print(string: String) -> String {
        return string.lowercased()
    }
}

//7.迭代器模式 Iterator Pattern:
struct Novella {
    let name: String
}

struct Novellas {
    let novellas: [Novella]
}

class NovellasIterator: IteratorProtocol {
    private let novellas: [Novella]
    private var current = 0
    init(novellas: [Novella]) {
        self.novellas = novellas
    }
    
    func next() -> Novella? {
        defer {
            current += 1
        }
        return novellas.count > current ? novellas[current] : nil
    }
}

extension Novellas: Sequence {
    func makeIterator() -> NovellasIterator {
        return NovellasIterator(novellas: novellas)
    }
}
//8.状态模式: 当改变对象内部状态时改变对象的行为
//游戏架构GKStateMachine
class Context {
    private var state: State = CloseState()
    
    func changeStateToOpen(name: String) {
        self.state = DoorOpenState(name: name)
    }
    
    func changeStateToClose() {
        self.state = CloseState()
    }
    
    var wind: String {
        return state.getWind(context: self)
    }
    
    var isClosed: Bool {
        return state.isClosed(context: self)
    }
}

protocol State {
    func getWind(context: Context) -> String
    func isClosed(context: Context) -> Bool
}

class DoorOpenState: State {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getWind(context: Context) -> String {
        return "\(name) whipppp"
    }
    func isClosed(context: Context) -> Bool {
         return false
    }
}

class CloseState: State {
    func getWind(context: Context) -> String {
        return ""
    }
    func isClosed(context: Context) -> Bool {
        return false
    }
}

//9.备忘录模式 Memento: 通过另一个对象记录对象状态而不破坏对象的封装性,需要做状态保存时使用
//实际应用NSUndoManager

typealias Memento = [String: String]

protocol MementoConvertible {
    var memento: Memento { get }
    init?(memento: Memento)
}

struct GameState: MementoConvertible {
    
    struct Keys {
        static let chapterKey = "chapterKey"
        static let weaponKey = "weapon"
    }
    
    var chapter: String
    var weapon: String
    
    init(chapter: String, weapon: String) {
        self.chapter = chapter
        self.weapon = weapon
    }
    
    init?(memento: Memento) {
        guard let chapter = memento[Keys.chapterKey], let weapon = memento[Keys.chapterKey] else { return nil }
        self.chapter = chapter
        self.weapon = weapon
    }
    
    var memento: Memento {
        return [Keys.chapterKey: chapter, Keys.weaponKey: weapon]
    }
}

class CheckPoint {
    class func save(memento: Memento, name: String) {
        let defaults = UserDefaults.standard
        defaults.set(memento, forKey: name)
        _ = defaults.synchronize()
    }
    
    class func restore(name: String) -> Memento? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: name) as? Memento
    }
}

//10.访客模式 Visitor Pattern: 分离结构和行为,为不同的数据结构提供相同的行为能力
protocol PlanetVisitor {
    func visit(planet: MoonJedah)
    func visit(planet: PlanetAlderaan)
}

protocol Planet {
    func accept(visitor: PlanetVisitor)
}

class MoonJedah: Planet {
    func accept(visitor: PlanetVisitor) {
        visitor.visit(planet: self)
    }
}

class PlanetAlderaan: Planet {
    func accept(visitor: PlanetVisitor) {
        visitor.visit(planet: self)
    }
}

class NameVisitor: PlanetVisitor {
    var name = ""
    func visit(planet: MoonJedah) {
        name = "Jedah"
    }
    
    func visit(planet: PlanetAlderaan) {
        name = "Alderaan"
    }
}
//11.解释器模式 Interpreter pattern: 根据给定的语法规则做语法解析
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1.单一职责原则
        let door = PanPanDoor()
        let opener = DoorOpener(door: door)
        opener.excute()
        let closer = DoorCloser(door: door)
        closer.excute()
        
        //2.
        let beam1 = LaserBaem()
        let beam2 = LaserBaem()
        let weapons = WeaponsComposite(weapons: [beam1,beam2])
        print(weapons.shoot())
        let rocket = Rocket()
        let weapons2 = WeaponsComposite(weapons: [beam1,rocket])
        print(weapons2.shoot())
        
        //3.
        let result = willReturnObjectOrError()
        if let error = result.1 as? RequestError {
            print(error.description)
        }
        
        //4.
        let delozan = Delozan()
        let brown = EmmteBrown(timeMachine: delozan)
        print(brown.travelInTime(time: 3600*20))
        
        //5.
        let school = School()
        let student1 = PrimaryStudent()
        let student2 = MiddleStudent()
        print(school.learn(age: student1))
        print(school.learn(age: student2))
        
        //designPatterns
        
        //2.
        var appointment1 = Appointment(name: "1", place: "1", desc: "111")
        var appointment2 = appointment1
        appointment2.desc = "22222"
        
        //4.
        let nsFactory = NumberHelper.factory(type: .ns)
        let nsNumber = nsFactory("1")
        _ = nsNumber.stringValue()
        let swiftFactory = NumberHelper.factory(type: .swift)
        let number2 = swiftFactory("2")
        _ = number2.stringValue()
        
        //5.
        let empire = StarBuilder { builder in
            builder.x = 10
            builder.y = 20
            builder.z = 30
        }
        _ = Star(builder: empire)
        
        // structural
        //1.
        let oldVedio = OldVedio()
        let vedioAdapter = VedioAadpter(target: oldVedio)
        let newVedio = NewVedio()
        
        func play(vedio: VedioAble) {
             vedio.play()
        }
        play(vedio: newVedio)
        play(vedio: vedioAdapter)
        
        //3.
        let coffee = SimpleCoffee()
        print(coffee.getIngredients())
        let milk = Milk(coffee: coffee)
        print(milk.getIngredients())
        let whip = WhipCoffee(coffee: coffee)
        print(whip.getIngredients())
        
        //4.
        let cirle = Circle()
        cirle.draw(fillColor: "red")
        let square = Square()
        let whiteBoard = WhiteBoard(shapes: [cirle, square])
        whiteBoard.draw(fillColor: "red")
        
        //6.
        let tv = TV()
        let vacuumCleaner = VacuumCleaner()
        let tvControl = RemoteControl(appliance: tv)
        tvControl.turnOn()
        let vacuumCleanerControl = RemoteControl(appliance: vacuumCleaner)
        vacuumCleanerControl.turnOn()
        
        //Behavior pattern
        
        //Observe Pattern
        let nameObserver = NameObserver()
        let wind = Wind(max: 1, mix: 1, name: "first")
        wind.observer = nameObserver
        wind.name = "second"
        
        //1.
        let htmlPhases = HTMLCodeGeneratorPhases()
        let jsonPhases = JSONCodeGeneratorPhases()
        let htmlcodeGenrator = CodeGenerator(delegate: htmlPhases)
        htmlcodeGenrator.crossComplice()
        let jsonGenerator = CodeGenerator(delegate: jsonPhases)
        jsonGenerator.crossComplice()
        
        //2.
        let ten = MoneyPile(value: 10, quantity: 6, next: nil)
        let twenty = MoneyPile(value: 20, quantity: 2, next: ten)
        let fifty = MoneyPile(value: 50, quantity: 2, next: twenty)
        let hundred = MoneyPile(value: 100, quantity: 1, next: fifty)
        let atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
        print(atm.canWithDraw(amount: 180))
        
        //5.
        let programmer1 = Prorammer(name: "1")
        let programmer2 = Prorammer(name: "2")
        let mediator = MessageMediator()
        mediator.add(programmer: programmer1)
        mediator.add(programmer: programmer2)
        mediator.send(message: "hello")
        
        //6.
        let lower = LowerStrategy()
        let printer = Pinter(strategy: lower)
        printer.sprint(string: "DDASDAS")
        
        //8.
        let context = Context()
        context.changeStateToOpen(name: "123")
        print(context.isClosed)
        print(context.wind)
        context.changeStateToClose()
        print(context.isClosed)
        print(context.wind)
        
        //9.
        var gameState = GameState(chapter: "1", weapon: "111")
        gameState.chapter = "2"
        gameState.weapon = "222"
        CheckPoint.save(memento: gameState.memento, name: "one chapter")
        gameState.chapter = "3"
        gameState.weapon = "333"
        CheckPoint.save(memento: gameState.memento, name: "third chapter")
        
        if let restoreState = CheckPoint.restore(name: "one chapter") {
            let sState = GameState(memento: restoreState)
            dump(sState)
        }
        
        //10.
        let nameVisitor = NameVisitor()
        let Alderaan = PlanetAlderaan()
        let Jedah = MoonJedah()
        nameVisitor.visit(planet: Jedah)
        print(nameVisitor.name)
        nameVisitor.visit(planet: Alderaan)
        print(nameVisitor.name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//反思:
//避免跳入固化设计模式的陷阱,设计模式只是一种对面向对象的认知,是种典型的牺牲复杂度换取灵活性,不是唯一的解决方法,实际应用过重中一定是优先保证kss原则为第一优先(keep simple and stupid),对实际问题的处理要考虑是否需要灵活性,是否需要提高复杂度换取相应的灵活性
//设计模式和语言特性的冲突,函数式这种的声明式语言是否能根本的解决一些设计模式解决的问题:
//函数是第一对象可以传递的语言也就是可以将处理抽象传递,策略模式就不需要了比如filter函数,(c中也可以通过传函数指针实现,但是函数指针不能保证类型安全,引入了更高风险的crash)
//同样的,想保存处理能力的命令模式,也可以直接传递和保存函数了
//相似设计,对比和差异

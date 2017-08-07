// Playground - noun: a place where people can play

import UIKit

var theString: String?
theString = "Dies ist ein Familienrestaurant"
theString = theString?.uppercaseString

if (theString != nil) {
    println("theString: \(theString)")
} else {
    println("theString: No value, no future")
}

func isThereAString(inString: String?) -> Bool {
    if (inString != nil) {
        println("inString: \(inString)")
        return true
    } else {
        println("inString: No value, no future")
        return false
    }
}

isThereAString("Hallo")
isThereAString(nil)

func squareMeter(length : Int, width: Int) -> Int {
    return length * width
}

for i in 1...10{
    println(i)
}

squareMeter(5, 10)

func squareMeterWithPrice(length : Int, width: Int, inPrice: Int) -> (squareMeters: Int, price: Int) {
    var squareMeters = 0
    var price = 0
    squareMeters = length * width
    price = squareMeters * inPrice
    return (squareMeters, price)
}
squareMeterWithPrice(5, 10, 4000)


var theName = "Walter Sobchack"
theName += ", Bowling Champ"
let theExperte = "Karl Hungus"
var theExperteVar = theExperte
theExperteVar += ", TV-Experte"
//theExperte = theExperteVar

var theBoy : String = "Larry"
println(theBoy)
println("Der Autodieb heisst: \(theBoy)")

var theInt = 23
var theHexInt = 0x23
var theOctInt = 0o23
var theBinInt = 0b10111

var redLine = (0, "Punkte")
println(redLine.0)
println(redLine.1)
println("Smokey, Du hattest \(redLine.0) \(redLine.1)")

class Droid {
    let droidID : String
    let age : Int?
    
    convenience init(inDroid : String, inAge : Int?){
        println(inAge)
        self.init(inDroidID : inDroid)
    }
    
    init(inDroidID : String){
        self.droidID = "0xDEADBEEF\(inDroidID)"
    }
    
    func tellMyName() -> String {
        return "My name is \(droidID)"
    }
}

let theDroid = Droid(inDroid: "C3PO", inAge: 42)
theDroid.tellMyName()

//func printElements(inString : String) -> Int{
//    var theCounter = 0
//    for theElement in inString {
//        println(theElement)
//        theCounter++
//    }
//    return theCounter
//}

func printElements<T: SequenceType>(inObject : T) -> Int{
    var theCounter = 0
    for theElement in inObject {
        println(theElement)
        theCounter++
    }
    return theCounter
}

printElements("Guten Tag")

var theNewString : String? = "Foo"
println(theNewString!.uppercaseString)

class Building {
    var price : Int
    var agentCosts : Int
//    var buildingPrice : Int {
//        get {
//            return price + agentCosts
//        }
//    }

    var buildingPrice : Int {
            return price + agentCosts
    }

    init(inPrice : Int, inAgentCosts: Int){
        self.price = inPrice
        self.agentCosts = inAgentCosts
    }
}

let theBuilding = Building(inPrice: 400000, inAgentCosts: 40000)
theBuilding.buildingPrice

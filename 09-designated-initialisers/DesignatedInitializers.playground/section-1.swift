// Playground - noun: a place where people can play

import CocoaTouch

class Person {
  var name: String
  var age: Int?
  var consideredDangerous = false
  
  init(name: String, age: Int?) {
    self.name = name
    self.age = age
  }
  
  convenience init(name: String) {
    self.init(name: name, age: nil)
  }
  
}

enum Weapon {
  case Katana, Tsuba, Shuriken, Kusarigama, Fukiya
}

class Ninja: Person {
  var weapons: [Weapon]?
  
  init(name: String, age: Int?, weapons: [Weapon]?) {
    self.weapons = weapons
    
    super.init(name: name, age: age)
    
    self.consideredDangerous = true
  }
  
  convenience init(name: String) {
    self.init(name: name, age: nil, weapons: nil)
  }
}


let tony = Person(name: "tony")
tony.consideredDangerous
tony.age
tony.age = 43
tony


let tara = Person(name: "tara", age: 27)
tara.consideredDangerous
tara.age


let trevor = Ninja(name: "trevor")
trevor.age
trevor.consideredDangerous

let tina = Ninja(name: "tina", age: 23, weapons: [.Fukiya, .Tsuba])
tina.consideredDangerous
tina.weapons
tina.age



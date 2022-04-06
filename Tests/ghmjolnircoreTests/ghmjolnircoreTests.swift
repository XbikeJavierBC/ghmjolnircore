//
//  ghmjolnircoreTests.swift
//  ghmjolnircoreTests
//
//  Created by Javier Carapia on 22/01/22.
//

import XCTest
@testable import ghmjolnircore

class ghmjolnircoreTests: XCTestCase {
    func testOneExample() throws {
        self.fizzBuzz(n: 15)
    }
    
    func testTwoExample() throws {
        let foo = self.alphabeticWordsList(text: "I think the solution is fairly obvious.")
        let doo = self.alphabeticWordsList(text: "Chase two rabbits, catch none.")
        let ree = self.alphabeticWordsList(text: "We become what we think about.")
        let mii = self.alphabeticWordsList(text: "The quick brown fox jumped over the lazy dogs back.")
        
        let faa = self.alphabeticWordsList(text: " ")
        
        print(foo, doo, ree, mii, faa)
    }
    
    func testTreeExample() throws {
        let foo = self.simpleArraySum(ar: [1, 2, 3, 4, 10, 11])
        
        print(foo)
    }
    
    private func fizzBuzz(n: Int) -> Void {
        for i in 1...n {
            if (i % 3 == 0 && i % 5 == 0) {
                print("FizzBuzz")
            }
            else if (i % 3 == 0 && i % 5 != 0) {
                print("Fizz")
            }
            else if (i % 5 == 0 && i % 3 != 0) {
                print("Buzz")
            }
            else {
                print(i)
            }
        }
    }
    
    private func alphabeticWordsList(text: String) -> [String] {
        if text.isEmpty {
            return []
        }
        
        let separatedCharacter = " "
        let invaldCharacterList = Set(",.")
        
        let list = text
            .filter { !invaldCharacterList.contains($0) }
            .lowercased()
            .components(separatedBy: separatedCharacter)
            .filter { !$0.isEmpty }
        
        let min = list.map { $0.count }.min()
        
        return list.filter { $0.count == min }
    }
    
    private func simpleArraySum(ar: [Int]) -> Int {
        return ar.reduce(0) { $0 + $1 }
    }
}

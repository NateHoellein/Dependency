//
//  DependencyTests.swift
//  DependencyTests
//
//  Created by Nathan Hoellein on 10/23/21.
//

import XCTest
@testable import Dependency

class DependencyTests: XCTestCase {

    func testShouldResolveSampleClassA() throws {
        
        let dependencyManager = DependencyManager { manager in
            manager.register( { () -> SampleClassA in
                let sampleA = SampleClassA("this is sample class A")
                return sampleA
            }, "SampleClassA")
        }
        
        let sampleClassA: SampleClassA = try dependencyManager.resolve(label: "SampleClassA")
        
        XCTAssertEqual(sampleClassA.messageFromA, "this is sample class A")
    }
    
    func testShouldReturnNewInstanceOfDependency() {
        
        let dependencyManager = DependencyManager { manager in
            manager.register( { () -> SampleClassA in
                let sampleA = SampleClassA("this is sample class A")
                return sampleA
            }, "SampleClassA")
        }
        
        let sampleClassA: SampleClassA = try! dependencyManager.resolve(label: "SampleClassA")
        let sampleClassA1: SampleClassA = try! dependencyManager.resolve(label: "SampleClassA")
        
        XCTAssertTrue(sampleClassA !== sampleClassA1)
    }
    
    func testShouldBeAbleToResolveTwoDifferentClasses() {
        
        let dependencyManager = DependencyManager { manager in
            manager.register( { () -> SampleClassA in
                return SampleClassA("this is from sample A")
            }, "SampleClassA")
            
            manager.register({ () -> SampleClassB in
                return SampleClassB("this is from sample B")
            }, "SampleClassB")
        }
        
        let sampleA: SampleClassA = try! dependencyManager.resolve(label: "SampleClassA")
        let sampleB: SampleClassB = try! dependencyManager.resolve(label: "SampleClassB")
        
        XCTAssertEqual(sampleA.messageFromA, "this is from sample A")
        XCTAssertEqual(sampleB.messageFromB, "this is from sample B")
    }
    
    func testShouldThrowIfResolvingWhenNothingRegistered() {
        let dependencyManager = DependencyManager()
        
        do {
            _ = try dependencyManager.resolve(label: "SampleClassA") as SampleClassA
        } catch DependencyError.RegistrationOfClassNotFound{
            
        } catch {
            XCTFail("Expected a DependencyError.RegistrationOcClassNotFound")
        }
    }
    
    func testShouldBeAbleToInjectAParameter() {
        let dependencyManager = DependencyManager { manager in
            manager.register( { () -> SampleClassA in
                return SampleClassA("this is from sample A")
            }, "SampleClassA")
            
            manager.register({ () -> SampleClassB in
                return SampleClassB("this is from sample B")
            }, "SampleClassB")
            
            manager.register({ () -> SampleClassC in
                let b: SampleClassB = try! manager.resolve(label: "SampleClassB")
                return SampleClassC(sampleB: b, "this is from sample C")
            }, "SampleClassC")
        }
        
        let sampleA: SampleClassA = try! dependencyManager.resolve(label: "SampleClassA")
        let sampleC: SampleClassC = try! dependencyManager.resolve(label: "SampleClassC")
        
        XCTAssertEqual(sampleA.messageFromA, "this is from sample A")
        XCTAssertEqual(sampleC.messageFromC, "this is from sample C")
        XCTAssertEqual(sampleC.classB.messageFromB, "this is from sample B")
    }
    
    class SampleClassA {
        var messageFromA: String = ""
        
        init( _ message : String) {
            self.messageFromA = message
        }
    }
    
    class SampleClassB {
        var messageFromB: String = ""
        
        init(_ message: String) {
            self.messageFromB = message
        }
    }
    
    class SampleClassC {
        var classB: SampleClassB
        var messageFromC: String = ""
        
        init(sampleB: SampleClassB, _ message: String) {
            self.classB = sampleB
            self.messageFromC = message
        }
    }
}



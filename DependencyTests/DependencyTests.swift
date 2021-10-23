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
}



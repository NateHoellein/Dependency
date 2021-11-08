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
            manager.register(SampleClassA.self,  { (_) -> SampleClassA in
                let sampleA = SampleClassA("this is sample class A")
                return sampleA
            }, "SampleClassA")
        }
        
        let sampleClassA: SampleClassA = try dependencyManager.resolve(SampleClassA.self, label: "SampleClassA")
        
        XCTAssertEqual(sampleClassA.messageFromA, "this is sample class A")
    }
    
    func testShouldReturnNewInstanceOfDependency() {
        
        let dependencyManager = DependencyManager { manager in
            manager.register(SampleClassA.self,  { (_) -> SampleClassA in
                let sampleA = SampleClassA("this is sample class A")
                return sampleA
            }, "SampleClassA")
        }
        
        let sampleClassA: SampleClassA = try! dependencyManager.resolve(SampleClassA.self, label: "SampleClassA")
        let sampleClassA1: SampleClassA = try! dependencyManager.resolve(SampleClassA.self, label: "SampleClassA")
        
        XCTAssertTrue(sampleClassA !== sampleClassA1)
    }
    
    func testShouldBeAbleToResolveTwoDifferentClasses() {
        
        let dependencyManager = DependencyManager { manager in
            manager.register(SampleClassA.self,  { (_) -> SampleClassA in
                return SampleClassA("this is from sample A")
            }, "SampleClassA")
            
            manager.register(SampleClassB.self, { (_) -> SampleClassB in
                return SampleClassB("this is from sample B")
            }, "SampleClassB")
        }
        
        let sampleA: SampleClassA = try! dependencyManager.resolve(SampleClassA.self, label: "SampleClassA")
        let sampleB: SampleClassB = try! dependencyManager.resolve(SampleClassB.self, label: "SampleClassB")
        
        XCTAssertEqual(sampleA.messageFromA, "this is from sample A")
        XCTAssertEqual(sampleB.messageFromB, "this is from sample B")
    }
    
    func testShouldThrowIfResolvingWhenNothingRegistered() {
        let dependencyManager = DependencyManager()
        
        do {
            _ = try dependencyManager.resolve(SampleClassA.self, label: "SampleClassA") as SampleClassA
        } catch DependencyError.RegistrationOfClassNotFound{
            
        } catch {
            XCTFail("Expected a DependencyError.RegistrationOcClassNotFound")
        }
    }
    
    func testShouldThrowIfCannotCastToCreateFunction() {
        let dependencyManager = DependencyManager()
        dependencyManager.register(SampleClassA.self, { manager in
            return SampleClassA("This is sample A")
        }, "SampleClassA")
        
        do {
            var _: SampleClassA = try dependencyManager.resolve(SampleClassA.self, label: "SampleClassA")
        } catch DependencyError.UnableToInvokeCreationClosure(""){
            print("CAUGHT")
        } catch {
            XCTFail("Expected a DependencyError.RegistrationOcClassNotFound")
        }
       
    }
    
    func testShouldBeAbleToInjectAParameter() {
        let dependencyManager = DependencyManager { manager in
            manager.register( SampleClassA.self, { (_) -> SampleClassA in
                return SampleClassA("this is from sample A")
            }, "SampleClassA")
            
            manager.register(SampleClassB.self, { (_) -> SampleClassB in
                return SampleClassB("this is from sample B")
            }, "SampleClassB")
            
            manager.register(SampleClassC.self, { (dmanager) -> SampleClassC in
                let b: SampleClassB = try! dmanager.resolve(SampleClassB.self, label: "SampleClassB")
                return SampleClassC(sampleB: b, "this is from sample C")
            }, "SampleClassC")
        }
        
        let sampleA: SampleClassA = try! dependencyManager.resolve(SampleClassA.self, label: "SampleClassA")
        let sampleC: SampleClassC = try! dependencyManager.resolve(SampleClassC.self, label: "SampleClassC")
        
        XCTAssertEqual(sampleA.messageFromA, "this is from sample A")
        XCTAssertEqual(sampleC.messageFromC, "this is from sample C")
        XCTAssertEqual(sampleC.classB.messageFromB, "this is from sample B")
    }
    
//
//    func xtestHandleCircularReferences() {
//        let dependencyManager = DependencyManager { manager in
//            manager.register({ (dmanager) -> ParentClass in
//                let child: ChildClass = try! dmanager.resolve(label: "ChildClass")
//                return ParentClass(child: child)
//            }, "ParentClass")
//
//            manager.register({ (dmanager) -> ChildClass in
//                let parent: ParentClass = try! dmanager.resolve(label: "ParentClass")
//                return ChildClass(parent: parent)
//            }, "ChildClass")
//        }
//
//        let parent: ParentClass = try! dependencyManager.resolve(label: "ParentClass")
//        let child: ChildClass = try! dependencyManager.resolve(label: "ChildClass")
//
//        XCTAssertNotNil(parent)
//        XCTAssertNotNil(child)
//    }
    
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
    
    class ParentClass {
        var child: ChildClass
        init(child: ChildClass) {
            self.child = child
        }
    }
    
    class ChildClass {
        var parent: ParentClass
        init(parent: ParentClass) {
            self.parent = parent
        }
    }
}



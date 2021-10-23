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
            manager.register( {
                return SampleClassA()
            }, "SampleClassA")
        }
        
        let sampleClassA = dependencyManager.resolve(label: "SampleClassA") as SampleClassA
        
        XCTAssertTrue(sampleClassA is SampleClassA)
    }
}

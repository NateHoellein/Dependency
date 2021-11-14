//
//  DependencyContainer.swift
//  SampleApp
//
//  Created by Nathan Hoellein on 11/14/21.
//

import Dependency

class DependencyContainer {
    static let shared: DependencyManager = {
        
       
        return DependencyManager()
    }()
    
    
    
}

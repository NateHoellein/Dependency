//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Nathan Hoellein on 11/7/21.
//

import UIKit
import Dependency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var dependencyManager: DependencyManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Registration of dependencies.  How you implement this could vary. The DependencyManager class could b
        // wrapped in a singleton.  In this example, to get something up and running, it's just a global variable.
        // Definately not production ready quality
        
        dependencyManager = DependencyManager { manager in
            
            manager.register(SearchViewModel.self, { (_) -> SearchViewModel in
                return SearchViewModel()
            }, "searchViewModel")
            
            manager.register(APIProtocol.self, { (_) -> APIProtocol in
                return APIHandler()
            }, "APIHandler")
            
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


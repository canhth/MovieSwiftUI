//
//  AppDelegate.swift
//  SwiftUIMovies
//
//  Created by Canh Tran Wizeline on 7/29/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let movies = MoviesAPI.fetchData.fetchMovies(at: 1)
            .map { result -> (PaginatedResponse<Movie>?, NetworkError?) in
                switch result {
                case let .success(signup):
                    print(signup)
                case let .failure(error):
                    print(error)
                }
                return (nil, nil)
        }
        
        movies.sink { (result) in
            print(result)
        }
        
        
//        let a = Authentication.signUp(email: "hoangcanhsek6@gmail.com", password: "123123", grantType: "").signUp()
//            .map { result -> (SignUp?, String?) in
//                switch result {
//                case let .success(signup):
//                    print(signup)
//                case let .failure(error):
//                    print(error)
//                }
//                return (nil, nil)
//        }
//
//        a.sink { (result) in
//            print("Received")
//        }
        
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


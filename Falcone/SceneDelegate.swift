//
//  SceneDelegate.swift
//  Falcone
//
//  Created by Mohd Wasif Raza on 19/09/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navCon = UINavigationController()
        navCon.viewControllers = [ViewController()]
        navCon.topViewController?.navigationItem.title = "Finding Falcone!"
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navCon
        window?.makeKeyAndVisible()
    }

}


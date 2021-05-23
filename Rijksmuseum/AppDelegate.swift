//
//  AppDelegate.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      let window = UIWindow(frame: UIScreen.main.bounds)
      
      Application.shared.configureMainInterface(in: window)
      
      Log.initializeLogging()
      
      self.window = window
      
      self.window?.makeKeyAndVisible()
        
      return true
    }

}


//
//  Application.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import UIKit
import Foundation

final class Application {
  static let shared = Application()

  private let networkUseCaseProvider: NetworkProvider
  
  var window: UIWindow?
  
  private init() {
    self.networkUseCaseProvider = NetworkProvider()
  }
  
  func configureMainInterface(in window: UIWindow) {
    self.window = window
    openOverview()
  }
  
  func openOverview() {
    let storyboard = UIStoryboard(name: "Overview", bundle: nil)
    let navigationController = UINavigationController()
    let mainNavigator = OverviewNavigator(network: networkUseCaseProvider,
                                                     navigationController: navigationController,
                                                     storyBoard: storyboard)
    let vc = UIViewController()
    
    vc.view.backgroundColor = .blue
    
    mainNavigator.toOverview()

    window?.rootViewController = navigationController
  }
}

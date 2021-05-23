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
    let vc = OverviewViewController()
    let navigationController = UINavigationController(rootViewController: vc)
    let overviewNavigator = OverviewNavigator(network: networkUseCaseProvider,
                                                     navigationController: navigationController)
    
    vc.viewModel = OverviewViewModel(useCase: networkUseCaseProvider.makeCollectionNetwork(),
                                    navigator: overviewNavigator)

    window?.rootViewController = navigationController
  }
}

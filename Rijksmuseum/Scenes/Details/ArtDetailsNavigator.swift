//
//  ArtDetailsNavigator.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/24.
//

import UIKit
import RxSwift

protocol ArtDetailsNavigatorProtocol {
  func toOverview()
}

class ArtDetailsNavigator: ArtDetailsNavigatorProtocol {
  
  let navigationController: UINavigationController
  let network: NetworkProvider
  
  init(network: NetworkProvider,
       navigationController: UINavigationController) {
    self.network = network
    self.navigationController = navigationController
  }
  
  func toOverview() {
    self.navigationController.popViewController(animated: true)
  }
    
}

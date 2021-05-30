//
//  OverviewNavigator.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import UIKit
import RxSwift

protocol OverviewNavigatorProtocol {
  func toOverview()
  func toArtDetails(_ art: ArtObjectModel)
}

class OverviewNavigator: OverviewNavigatorProtocol {
  let navigationController: UINavigationController
  let network: NetworkProvider
  
  init(network: NetworkProvider,
       navigationController: UINavigationController) {
    self.network = network
    self.navigationController = navigationController
  }
  
  func toOverview() {
    let vc = OverviewViewController()
    vc.viewModel = OverviewViewModel(useCase: network.makeCollectionNetwork(),
                                    navigator: self)
    navigationController.pushViewController(vc, animated: true)
  }

  func toArtDetails(_ art: ArtObjectModel) {
    let navigator = ArtDetailsNavigator(network: network, navigationController: navigationController)
    let vc = ArtDetailsViewController()
    let viewModel = ArtDetailsViewModel(useCase: network.makeCollectionNetwork(), navigator: navigator, art: art)
    vc.viewModel = viewModel
    navigationController.pushViewController(vc, animated: true)
  }
    
}

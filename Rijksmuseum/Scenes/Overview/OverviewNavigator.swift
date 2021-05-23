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
//    let storyboard = UIStoryboard(name: "Meaning", bundle: nil)
//    let navigator = MeaningNavigator(network: network, navigationController: navigationController, storyBoard: storyboard)
//    let vc = storyboard.instantiateViewController(ofType: MeaningViewController.self)
//    let viewModel = MeaningViewModel(useCase: network.makeVocabularyNetwork(), navigator: navigator, word: word, meaning: meaning)
//    vc.viewModel = viewModel
//    navigationController.pushViewController(vc, animated: true)
  }
    
}

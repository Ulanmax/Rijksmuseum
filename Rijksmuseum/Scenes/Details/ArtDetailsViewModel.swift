//
//  ArtDetailsViewModel.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ArtDetailsViewModel: ViewModelType {

    private let art: ArtObjectModel
    
    struct Input {
      let trigger: Driver<Void>
    }
    struct Output {
      let fetching: Driver<Bool>
      let title: Driver<String>
      let message: Driver<String>
      let imageUrl: Driver<URL?>
      let error: Driver<Error>
    }
    
    private let useCase: CollectionNetworkProtocol
    private let navigator: ArtDetailsNavigatorProtocol
    
    init(useCase: CollectionNetworkProtocol, navigator: ArtDetailsNavigatorProtocol, art: ArtObjectModel) {
      self.useCase = useCase
      self.navigator = navigator
      self.art = art
    }
    
    func transform(input: Input) -> Output {
      let activityIndicator = ActivityIndicator()
      let errorTracker = ErrorTracker()
      
      let fetching = activityIndicator.asDriver()
      let errors = errorTracker.asDriver()
      
      let art = Driver.just(self.art).startWith(self.art)
        
      let title = art.map {$0.title}
      
      let message = art.map {$0.longTitle}
        
      let imageUrl = art.map {
        URL(string: $0.webImage.url)
      }
      
      return Output(fetching: fetching,
                    title: title,
                    message: message,
                    imageUrl: imageUrl,
                    error: errors)
    }
}


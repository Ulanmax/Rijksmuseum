//
//  ArtDetailsViewModel.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxNuke
import Nuke

final class ArtDetailsViewModel: ViewModelType {
  private let art: ArtObjectModel
  
  struct Input {}
  struct Output {
    let fetching: Driver<Bool>
    let title: Driver<String>
    let message: Driver<String>
    let image: Driver<UIImage>
    let error: Driver<Error>
  }
  
  private let useCase: CollectionNetworkProtocol
  private let navigator: ArtDetailsNavigatorProtocol
  
  private let options: ImageLoadingOptions = {
    var options = ImageLoadingOptions(placeholder:UIImage(named: "photo"), transition: .fadeIn(duration: 0.25))
    options.pipeline = Nuke.ImagePipeline.shared
    return options
  }()
  
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
    
    let artObserver = Driver.just(self.art)
      
    let title = artObserver.map {$0.title}
    
    let message = artObserver.map {$0.longTitle}
    
    let isBusy = ActivityIndicator()
    
    let imageUrl = artObserver.filter({ URL(string: $0.webImage.url)?.absoluteString != "" }).map({ URL(string: $0.webImage.url)! })
    
    let image = imageUrl.flatMapLatest { url in
      return self.options.pipeline!.rx.loadImage(with: url)
        .trackActivity(isBusy)
        .asDriverOnErrorJustComplete()
    }.map { $0.image }
    
    return Output(fetching: fetching,
                  title: title,
                  message: message,
                  image: image,
                  error: errors)
  }
}


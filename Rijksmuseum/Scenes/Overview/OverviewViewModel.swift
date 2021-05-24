//
//  OverviewViewModel.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum SectionItem {
  case artObjectSectionItem(art: ArtObjectCellViewModel)
}

enum CollectionSectionModel: Equatable {
  static func == (lhs: CollectionSectionModel, rhs: CollectionSectionModel) -> Bool {
    lhs.title == rhs.title
  }
  case imageProvidableSection(title: String, items: [SectionItem])
}

extension CollectionSectionModel: SectionModelType {
  typealias Item = SectionItem

  var items: [Item] {
    switch  self {
    case .imageProvidableSection(title: _, items: let items):
      return items.map {$0}
    }
  }

  init(original: CollectionSectionModel, items: [Item]) {
    switch original {
    case let .imageProvidableSection(title: title, items: _):
      self = .imageProvidableSection(title: title, items: items)
    }
  }
}

extension CollectionSectionModel {
  var title: String {
    switch self {
    case .imageProvidableSection(title: let title, items: _):
      return title
    }
  }
}

final class OverviewViewModel: ViewModelType {
  struct Input {
    let trigger: Driver<Void>
    let nextPageTrigger: Driver<CGPoint>
    let selection: Driver<IndexPath>
  }
  struct Output {
    let fetching: Driver<Bool>
    let sections: Driver<[CollectionSectionModel]>
    let selectedArt: Driver<Void>
    let error: Driver<Error>
  }
  
  private let useCase: CollectionNetworkProtocol
  private let navigator: OverviewNavigatorProtocol
  private let pageSize = 20
  private var page = 0
  
  private var collections: [CollectionSectionModel] = []
  
  init(useCase: CollectionNetworkProtocol, navigator: OverviewNavigatorProtocol) {
    self.useCase = useCase
    self.navigator = navigator
  }
  
  func transform(input: Input) -> Output {
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
      
    let fetching = activityIndicator.asDriver()
    let errors = errorTracker.asDriver()
      
    let sections = input.nextPageTrigger
      .flatMapLatest { _ -> SharedSequence<DriverSharingStrategy, [ArtObjectModel]> in
        self.page += 1
        return self.useCase.getArts(page: self.page, pageSize: self.pageSize)
          .trackActivity(activityIndicator)
          .trackError(errorTracker)
          .asDriverOnErrorJustComplete()
      }.map { [self] arts -> [CollectionSectionModel] in
        let sectionItems = arts.map { SectionItem.artObjectSectionItem(art: ArtObjectCellViewModel(with: $0)) }
        collections.append(CollectionSectionModel.imageProvidableSection(title: "Collection of art objects",
                                  items: sectionItems))
        
        return collections
      }
      
    let selectedArt = input.selection.withLatestFrom(sections) { (indexPath, sections) -> SectionItem in
      let section = sections[indexPath.section]
      return section.items[indexPath.row]
    }
    .do(onNext:
          { [weak self] sectionItem in
            switch sectionItem {
            case let .artObjectSectionItem(cellModel):
              if let art = cellModel.art {
                self?.navigator.toArtDetails(art)
              }
            }
          }
    ).mapToVoid()
      
    return Output(fetching: fetching,
                  sections: sections,
                  selectedArt: selectedArt,
                  error: errors)
  }
}

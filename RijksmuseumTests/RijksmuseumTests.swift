//
//  RijksmuseumTests.swift
//  RijksmuseumTests
//
//  Created by Maks Niagolov on 2021/05/21.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Rijksmuseum

class RijksmuseumTests: XCTestCase {
    
  var viewModel : OverviewViewModel!
  var detailsViewModel : ArtDetailsViewModel!
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  fileprivate var service : MockCollectionNetwork!
  fileprivate var navigator : MockOverviewNavigator!
  fileprivate var detailsNavigator : MockArtDetailsNavigator!

  override func setUp() {
    super.setUp()
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    self.service = MockCollectionNetwork()
    self.navigator = MockOverviewNavigator()
    self.detailsNavigator = MockArtDetailsNavigator()
    self.viewModel = OverviewViewModel(useCase: self.service, navigator: self.navigator)
  }

  override func tearDown() {
    self.viewModel = nil
    self.service = nil
    self.navigator = nil
    super.tearDown()
  }

  func testFetchArts() {

    let sections = scheduler.createObserver([CollectionSectionModel].self)
    
    let imageModel = ImageModel(guid: "", offsetPercentageX: 0, offsetPercentageY: 0, width: 0, height: 0, url: "ttps://lh3.googleusercontent.com/J-mxAE7CPu-DXIOx4QKBtb0GC4ud37da1QK7CzbTIDswmvZHXhLm4Tv2-1H3iBXJWAW_bHm7dMl3j5wv_XiWAg55VOM=s0")

    let artObject = ArtObjectModel(id: "", title: "art 1", principalOrFirstMaker: "principal 1", longTitle: "art 1 details", webImage: imageModel, headerImage: imageModel)
    
    service.artObject = artObject
    
    let contentOffset = scheduler.createHotObservable([Recorded.next(10, CGPoint())]).asDriverOnErrorJustComplete()
    
    let input = OverviewViewModel.Input(
        nextPageTrigger: contentOffset,
        selection: .empty()
    )
    
    let output = viewModel.transform(input: input)

    // bind the result
    output.sections
        .drive(sections)
        .disposed(by: disposeBag)

    scheduler.start()
    
    let sectionItems = [SectionItem.artObjectSectionItem(art: ArtObjectCellViewModel(with: artObject))]
    let result = [
      CollectionSectionModel.imageProvidableSection(
        title: "Collection of art objects",
        items: sectionItems
      )
    ]

    XCTAssertEqual(sections.events, [.next(10, result)])
  }

  func testArtDetails() {

    let titleObserver = scheduler.createObserver(String.self)
    let messageObserver = scheduler.createObserver(String.self)
    
    let imageModel = ImageModel(guid: "", offsetPercentageX: 0, offsetPercentageY: 0, width: 0, height: 0, url: "ttps://lh3.googleusercontent.com/J-mxAE7CPu-DXIOx4QKBtb0GC4ud37da1QK7CzbTIDswmvZHXhLm4Tv2-1H3iBXJWAW_bHm7dMl3j5wv_XiWAg55VOM=s0")

    let artObject = ArtObjectModel(id: "", title: "art 1", principalOrFirstMaker: "principal 1", longTitle: "art 1 details", webImage: imageModel, headerImage: imageModel)
    
    self.detailsViewModel = ArtDetailsViewModel(useCase: self.service, navigator: self.detailsNavigator, art: artObject)
    
    let input = ArtDetailsViewModel.Input()
    
    let output = detailsViewModel.transform(input: input)

    // bind the result
    output.title
        .drive(titleObserver)
        .disposed(by: disposeBag)
    
    output.message
        .drive(messageObserver)
        .disposed(by: disposeBag)

    scheduler.start()

    XCTAssertEqual(titleObserver.events, [.next(0, artObject.title), .completed(0)])
    XCTAssertEqual(messageObserver.events, [.next(0, artObject.longTitle), .completed(0)])
  }
}

fileprivate class MockCollectionNetwork: CollectionNetworkProtocol {
    
  var artObject : ArtObjectModel?
    
  func getArts(page: Int, pageSize: Int) -> Observable<[ArtObjectModel]> {
    return Observable.just([artObject!])
  }
}

fileprivate class MockOverviewNavigator: OverviewNavigatorProtocol {
  func toOverview() {
  }
  
  func toArtDetails(_ art: ArtObjectModel) {
  }
}

fileprivate class MockArtDetailsNavigator: ArtDetailsNavigatorProtocol {
  func toOverview() {
  }
}

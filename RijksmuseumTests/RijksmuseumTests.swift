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
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  fileprivate var service : MockCollectionNetwork!
  fileprivate var navigator : MockOverviewNavigator!

  override func setUp() {
    super.setUp()
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    self.service = MockCollectionNetwork()
    self.navigator = MockOverviewNavigator()
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
    
    let trigger = scheduler.createHotObservable([Recorded.next(10, ())]).asDriverOnErrorJustComplete()
    let contentOffset = scheduler.createHotObservable([Recorded.next(10, CGPoint())]).asDriverOnErrorJustComplete()
    
    let input = OverviewViewModel.Input(
        trigger: trigger,
        nextPageTrigger: contentOffset,
        selection: .empty()
    )
    
    let output = viewModel.transform(input: input)

    // bind the result
    output.sections
        .drive(sections)
        .disposed(by: disposeBag)

    scheduler.start()
    
//    let result = [CollectionSectionModel(with: wordModel.meanings.first!, word: wordModel.text)]
    
    let sectionItems = [SectionItem.artObjectSectionItem(art: ArtObjectCellViewModel(with: artObject))]
    let result = [
      CollectionSectionModel.imageProvidableSection(
        title: "Collection of art objects",
        items: sectionItems
      )
    ]

    XCTAssertEqual(sections.events, [.next(10, result)])
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

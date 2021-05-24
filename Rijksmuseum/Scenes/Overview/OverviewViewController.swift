//
//  OverviewViewController.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

typealias CollectionDataSource = RxCollectionViewSectionedReloadDataSource<CollectionSectionModel>

class OverviewViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  var viewModel: OverviewViewModel!
    
  fileprivate lazy var imageListCollectionView: UICollectionView = {

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.scrollDirection = .vertical
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 40)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Utilities.classNameAsString(obj: HeaderCell.self))
    collectionView.register(ArtObjectCell.self,
                            forCellWithReuseIdentifier: Utilities.classNameAsString(obj: ArtObjectCell.self))
    collectionView.bounces = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    return collectionView
  }()

  private lazy var dataSource: CollectionDataSource = {
    return CollectionDataSource(configureCell: { dataSource, collectionView, indexPath, data in
      switch dataSource[indexPath.section] {
       case let .imageProvidableSection(title, items) :
        guard let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: Utilities.classNameAsString(obj: ArtObjectCell.self),
                               for: indexPath) as? ArtObjectCell else {
                                return ArtObjectCell()
        }
        if case let .artObjectSectionItem(art) = data {
          cell.setup(with: art)
        }
        return cell
      }
    })
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupBindings()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func setupUI() {
    title = "Rijksmuseum"
    view.backgroundColor = .white
    view.addSubview(imageListCollectionView)

    imageListCollectionView.snp.makeConstraints({
      $0.top.trailing.equalToSuperview()
      $0.leading.trailing.bottom.equalToSuperview()
    })
  }
      
  private func setupBindings() {
    
    guard let viewModel = self.viewModel else {
        return
    }
    
    let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
    .mapToVoid()
    .asDriverOnErrorJustComplete()
    
    let contentOffset = imageListCollectionView.rx.contentOffset.asDriver()
        .filter({ (value) -> Bool in
            return self.imageListCollectionView.contentOffset.y + self.imageListCollectionView.frame.size.height + 20.0 > self.imageListCollectionView.contentSize.height
        })

    let input = OverviewViewModel.Input(
        trigger: viewDidAppear,
        nextPageTrigger: contentOffset,
        selection: imageListCollectionView.rx.itemSelected.asDriver()
    )
    let output = viewModel.transform(input: input)
    
    dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Utilities.classNameAsString(obj: HeaderCell.self), for: indexPath) as! HeaderCell
      header.setup(indexPath.section)
      return header
    }
    
    output.sections.asObservable()
    .bind(to: imageListCollectionView.rx.items(dataSource: self.dataSource))
    .disposed(by: self.disposeBag)

    [
        output.error.drive(errorBinding),
        output.selectedArt.drive()
    ]
    .forEach({$0.disposed(by: disposeBag)})
  }
}

extension OverviewViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width - 20, height: 350)
  }
}


//
//  ArtObjectCell.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxNuke
import Nuke

class ArtObjectCell: UICollectionViewCell {
  
  var viewModel: ArtObjectCellViewModel?
  
  var pipeline = Nuke.ImagePipeline.shared
  
  var disposeBagCell:DisposeBag = DisposeBag()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    label.numberOfLines = 2
    return label
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .gray
    return imageView
  }()

  func setup(with model: ArtObjectCellViewModel) {
    layer.cornerRadius = 16
    layer.masksToBounds = true

    addSubview(imageView)
    imageView.addSubview(titleLabel)

    setupLayouts()

    self.viewModel = model
    
    self.titleLabel.text = model.text
    
    if let url = model.imageUrl, url.absoluteString != "" {
      var options = makeImageLoadingOptions()
      options.pipeline = self.pipeline
      
      let isBusy = ActivityIndicator()
      
      self.imageView.image = nil
      
      self.pipeline.rx.loadImage(with: url)
        .trackActivity(isBusy)
          .subscribe(onNext: { [weak self] value in
              self?.imageView.image = value.image
          })
          .disposed(by: disposeBagCell)
    }
  }

  private func setupLayouts() {
    imageView.snp.makeConstraints({
      $0.edges.equalToSuperview()
    })
    titleLabel.snp.makeConstraints({
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(16)
    })
  }
  
  func makeImageLoadingOptions() -> ImageLoadingOptions {
      return ImageLoadingOptions(transition: .fadeIn(duration: 0.25))
  }
  
  override func prepareForReuse() {
    disposeBagCell = DisposeBag()
  }
}

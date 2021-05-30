//
//  ArtDetailsViewController.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/24.
//

import UIKit
import RxSwift
import RxCocoa

class ArtDetailsViewController: UIViewController {
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    label.numberOfLines = 2
    return label
  }()
  
  private let messageLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    label.numberOfLines = 0
    return label
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .gray
    return imageView
  }()
    
  private let disposeBag = DisposeBag()
  
  var viewModel: ArtDetailsViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    makeSubviewsLayout()
    setupBindings()
  }
  
  private func setupUI() {
    view.addSubview(imageView)
    imageView.addSubview(titleLabel)
    imageView.addSubview(messageLabel)
  }
  
  private func makeSubviewsLayout() {
    imageView.snp.makeConstraints({
      $0.edges.equalToSuperview()
    })
    titleLabel.snp.makeConstraints({
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().inset(16)
    })
    messageLabel.snp.makeConstraints({ [weak titleLabel] in
      guard let titleLabel = titleLabel else { return }
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(32)
    })
  }
    
  private func setupBindings() {
    guard let viewModel = self.viewModel else {
      return
    }
    
    let input = ArtDetailsViewModel.Input()
    let output = viewModel.transform(input: input)
    
    [
      output.title.drive(titleLabel.rx.text),
      output.message.drive(messageLabel.rx.text),
      output.image.drive(imageView.rx.image),
      output.error.drive(errorBinding)
    ]
    .forEach({$0.disposed(by: disposeBag)})
  }
}

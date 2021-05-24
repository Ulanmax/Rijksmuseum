//
//  HeaderCell.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/23.
//

import UIKit

class HeaderCell: UICollectionViewCell {

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    label.numberOfLines = 2
    return label
  }()

  func setup(_ section: Int) {
    layer.cornerRadius = 16
    layer.masksToBounds = true

    addSubview(titleLabel)

    setupLayouts()

    self.titleLabel.text = "Collection \(section)"
  }

  private func setupLayouts() {
    titleLabel.snp.makeConstraints({
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
    })
  }
}

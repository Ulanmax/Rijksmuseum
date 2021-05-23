//
//  ArtObjectCellViewModel.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import Foundation
import UIKit

class ArtObjectCellViewModel: Equatable {
    
    var text: String = ""
    
    var imageUrl: URL?
    
    weak var art: ArtObjectModel?
    
    init(with art: ArtObjectModel) {
      self.update(with: art)
    }
    
    func update(with art: ArtObjectModel) {
      self.art = art
      self.text = art.title
      self.imageUrl = URL(string: art.webImage.url)
    }
    
    static func == (lhs: ArtObjectCellViewModel, rhs: ArtObjectCellViewModel) -> Bool {
      return lhs.text == rhs.text
    }
    
}

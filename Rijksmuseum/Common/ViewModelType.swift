//
//  ViewModelType.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import Foundation

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
    
  func transform(input: Input) -> Output
}

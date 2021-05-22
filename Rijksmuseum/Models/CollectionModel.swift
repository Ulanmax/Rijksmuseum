//
//  CollectionModel.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/22.
//

import Foundation

public class CollectionModel: Codable {
    
  public let elapsedMilliseconds: Int
  public let count: Int
  public let artObjects: [ArtObjectModel]
    
  public init(
    elapsedMilliseconds: Int,
    count: Int,
    artObjects: [ArtObjectModel]
  ) {
    self.elapsedMilliseconds = elapsedMilliseconds
    self.count = count
    self.artObjects = artObjects
  }
  
  private enum CodingKeys: String, CodingKey {
    case elapsedMilliseconds
    case count
    case artObjects
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
      
    elapsedMilliseconds = try container.decode(Int.self, forKey: .elapsedMilliseconds)
    count = try container.decode(Int.self, forKey: .count)
    artObjects = try container.decode([ArtObjectModel].self, forKey: .artObjects)  }
}


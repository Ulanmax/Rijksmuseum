//
//  ArtObjectModel.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import Foundation

public class ArtObjectModel: Codable {
    
  public let id: String
  public let title: String
  public let principalOrFirstMaker: String
  public let longTitle: String
  public let webImage: ImageModel
  public let headerImage: ImageModel
  
  public init(
    id: String,
    title: String,
    principalOrFirstMaker: String,
    longTitle: String,
    webImage: ImageModel,
    headerImage: ImageModel
  ) {
    self.id = id
    self.title = title
    self.principalOrFirstMaker = principalOrFirstMaker
    self.longTitle = longTitle
    self.webImage = webImage
    self.headerImage = headerImage
  }
  
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case principalOrFirstMaker
    case longTitle
    case webImage
    case headerImage
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
      
    id = try container.decode(String.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    principalOrFirstMaker = try container.decode(String.self, forKey: .principalOrFirstMaker)
    longTitle = try container.decode(String.self, forKey: .longTitle)
    webImage = try container.decode(ImageModel.self, forKey: .webImage)
    headerImage = try container.decode(ImageModel.self, forKey: .headerImage)
  }
}

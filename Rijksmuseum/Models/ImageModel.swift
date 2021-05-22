//
//  ImageModel.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import Foundation

public class ImageModel: Codable {
    
  public let guid: String
  public let offsetPercentageX: Int
  public let offsetPercentageY: Int
  public let width: Int
  public let height: Int
  public let url: String
    
  public init(
    guid: String,
    offsetPercentageX: Int,
    offsetPercentageY: Int,
    width: Int,
    height: Int,
    url: String
  ) {
    self.guid = guid
    self.offsetPercentageX = offsetPercentageX
    self.offsetPercentageY = offsetPercentageY
    self.width = width
    self.height = height
    self.url = url
  }
  
  private enum CodingKeys: String, CodingKey {
    case guid
    case offsetPercentageX
    case offsetPercentageY
    case width
    case height
    case url
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
      
    guid = try container.decode(String.self, forKey: .guid)
    offsetPercentageX = try container.decode(Int.self, forKey: .offsetPercentageX)
    offsetPercentageY = try container.decode(Int.self, forKey: .offsetPercentageY)
    width = try container.decode(Int.self, forKey: .width)
    height = try container.decode(Int.self, forKey: .height)
    url = try container.decode(String.self, forKey: .url)
  }
}

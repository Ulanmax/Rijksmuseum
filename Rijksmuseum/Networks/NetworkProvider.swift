//
//  NetworkProvider.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

final class NetworkProvider {
  private let apiEndpoint: String
  
  public init() {
    apiEndpoint = "https://www.rijksmuseum.nl/api/en"
  }
  
  public func makeCollectionNetwork() -> CollectionNetwork {
    let network = Network<CollectionModel>(apiEndpoint)
    return CollectionNetwork(network: network)
  }
}

//
//  CollectionNetwork.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import RxSwift

protocol CollectionNetworkProtocol : class {
    func getArts(page: Int, pageSize: Int) -> Observable<[ArtObjectModel]>
}

public final class CollectionNetwork: CollectionNetworkProtocol {
  private let network: Network<CollectionModel>

  private let path = "collection"

  init(network: Network<CollectionModel>) {
    self.network = network
  }

  public func getArts(page: Int, pageSize: Int) -> Observable<[ArtObjectModel]> {
    let params = ["p": page, "ps": pageSize] as [String : Any]
    return network.getItem(path, params: params).map({ result -> [ArtObjectModel] in
      return result.artObjects
    })
  }
}

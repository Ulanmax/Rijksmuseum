//
//  Network.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

final class Network<T: Codable> {
    
  private let endPoint: String
  private let scheduler: ConcurrentDispatchQueueScheduler
  
  init(_ endPoint: String) {
    self.endPoint = endPoint
    self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
  }
  
  func getItem(_ path: String, params: [String : Any] = [:]) -> Observable<T> {
    return self.getItem(path, responseType: T.self, params: params)
  }
  
  func getItems(_ path: String, params: [String : Any] = [:]) -> Observable<[T]> {
    return self.getItem(path, responseType: [T].self, params: params)
  }

  func getItem<Type: Codable>(_ path: String, responseType: Type.Type, params: [String : Any] = [:]) -> Observable<Type> {
    let headers: HTTPHeaders = [
      "Content-Type": "application/json"
    ]
    var allParams = params
    allParams["key"] = Constants.apiKey
    let absolutePath = "\(endPoint)/\(path)"
    return RxAlamofire
        .data(.get, absolutePath, parameters: allParams, headers: headers)
        .debug()
        .observeOn(scheduler)
        .map({ data -> Type in
          return try JSONDecoder().decode(Type.self, from: data)
        })
  }

}

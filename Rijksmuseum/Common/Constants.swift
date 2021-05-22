//
//  Constants.swift
//  Rijksmuseum
//
//  Created by Maks Niagolov on 2021/05/21.
//

import Foundation
import UIKit

struct Constants {
  static let apiKey: String = "0fiuZFh4"
}

public enum APIError: Error {
  case cannotParse
  case unknownError
  case connectionError
  case invalidCredentials
  case notFound
  case invalidResponse
  case serverError
  case serverUnavailable
  case timeOut
  case unsupportedURL
  case mailExist

  static func checkErrorCode(_ errorCode: Int) -> APIError {
      switch errorCode {
      case 401:
          return .invalidCredentials
      case 404:
          return .notFound
      case 409:
          return .mailExist
      default:
          return .unknownError
      }
  }
}

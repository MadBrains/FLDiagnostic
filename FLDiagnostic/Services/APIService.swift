//
//  ApiService.swift
//  Forward Leasing
//
//  Created by Данил on 02/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import Alamofire


enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

class APIService {
  static let shared = APIService()
  
  func pathDevice() -> Observable<Result<DeviceResponse, APIError>> {
    let params: Parameters = ["imei": DiagnosticService.shared.imei,
                  "os": "ios",
                  "brandName": "apple",
                  "modelName": DeviceService.deviceModel,
                  "imeis": [DiagnosticService.shared.imei],
                  "storageVolume": DeviceService.totalDiskSpaceInGB,
                  "color": NSNull()]
      return defaultRequest(FLEndpoint.devices, method: .patch, parameters: params, decodingType: DeviceResponse.self)
  }
  
  func getActiveDiagnostic() -> Observable<Result<DiagnosticResponse, APIError>> {
    return defaultRequest(FLEndpoint.diagnosticsActive, method: .get, decodingType: DiagnosticResponse.self)
  }
  
  func getDiagnoscicResult(_ id: String) -> Observable<Result<ResultResponse, APIError>> {
    return defaultRequest(FLEndpoint.diagnosticsResult(id), method: .get, decodingType: ResultResponse.self)
  }
  
  func cancelDiagnostic(_ id: String) -> Observable<Result<DefaultSuccessResponse, APIError>> {
        return defaultRequest(FLEndpoint.diagnosticsCancel(id), method: .post, decodingType: DefaultSuccessResponse.self)
  }
  
  func saveDiagnostic(_ id: String, _ tests: [Parameters], _ questions: [Parameters]) -> Observable<Result<DefaultSuccessResponse, APIError>> {
    let params: Parameters = ["osVersion": DeviceService.osVersion,
                              "batteryLevelOnStart": DiagnosticService.shared.batteryLevelOnStart,
                              "batteryLevelOnFinish": DeviceService.batteryLevel,
                              "tests": tests, "answers": questions]
    return defaultRequest(FLEndpoint.diagnosticsSave(id), method: .post, parameters: params, decodingType: DefaultSuccessResponse.self)
  }
  
  //swiftlint:disable line_length
  func defaultRequest<T: Codable>(_ edpoint: FLEndpoint, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, decodingType: T.Type) -> Observable<Result<T, APIError>> {
    print(edpoint.request)
    return Observable.create { (observable) -> Disposable in
      
      Alamofire.request(edpoint.request, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (string) in
        print(string)
      }).responseJSON { (response ) in
        if response.error != nil || response.data == nil {
          observable.onNext(.failure(.requestFailed))
        } else {
          if let data = response.data {
            do {
              let genericModel = try JSONDecoder().decode(decodingType, from: data)
                observable.onNext(.success(genericModel))
            } catch let error {
                print(error)
                observable.onNext(.failure(.jsonConversionFailure))
            }
          } else {
            observable.onNext(.failure(.invalidData))
          }
        }
      }
      
      return Disposables.create()
    }
    
  }

}

enum FLEndpoint {
  case login
  case diagnostics
  case devices
  case diagnosticsActive
  case diagnosticsCancel(_ id: String)
  case diagnosticsSave(_ id: String)
  case diagnosticsResult(_ id: String)
}

protocol Endpoint {
  var base: String { get }
  var path: String { get }
}

extension FLEndpoint: Endpoint {
    
    var base: String {
        return "https://dev19.arcdev.ru/api"
    }
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .diagnostics: return "/diagnostics/\(DiagnosticService.shared.id ?? "")"
        case .devices: return "/devices"
        case .diagnosticsActive: return "/diagnostics/active?deviceImei=\(DiagnosticService.shared.imei)"
        case .diagnosticsCancel(let id): return "/diagnostics/\(id)/cancel"
        case .diagnosticsSave(let id): return "/diagnostics/\(id)/results"
        case .diagnosticsResult(let id): return "/diagnostics/\(id)"
        }
    }
}

extension Endpoint {
  
    var request: URLConvertible {
        return base + path
    }
  
}

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case serverError
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .serverError: return "Server Error"
        }
    }
}

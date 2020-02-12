//
//  NetworkService.swift
//  Forward Leasing
//
//  Created by Данил on 20/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import Foundation
import Reachability
import RxSwift
import RxCocoa
import Alamofire

class NetworkManager: NSObject {
  typealias Status = Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus

  var reachability: Reachability!

  static let shared: NetworkManager = { return NetworkManager() }()
  
  private let manager = Alamofire.NetworkReachabilityManager(host: "apple.com")
  private(set) var status = BehaviorRelay<Status>(value: .notReachable)

  override init() {
      super.init()
      manager?.listener = { self.status.accept($0) }
      manager?.startListening()
    
      reachability = Reachability()!

      // Register an observer for the network status
      NotificationCenter.default.addObserver(
          self,
          selector: #selector(networkStatusChanged(_:)),
          name: .reachabilityChanged,
          object: reachability
      )

      do {
          // Start the network status notifier
          try reachability.startNotifier()
      } catch {
          print("Unable to start notifier")
      }
  }

  @objc func networkStatusChanged(_ notification: Notification) {
      // Do something globally here!
  }

  static func stopNotifier() -> Void {
      do {
          // Stop the network status notifier
          try (NetworkManager.shared.reachability).startNotifier()
      } catch {
          print("Error stopping notifier")
      }
  }

  // Network is reachable
  static func isReachable(completed: @escaping (NetworkManager) -> Void) {
      if (NetworkManager.shared.reachability).connection != .none {
          completed(NetworkManager.shared)
      }
  }

  // Network is unreachable
  static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
      if (NetworkManager.shared.reachability).connection == .none {
          completed(NetworkManager.shared)
      }
  }

  // Network is reachable via WWAN/Cellular
  static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
      if (NetworkManager.shared.reachability).connection == .cellular {
          completed(NetworkManager.shared)
      }
  }

  // Network is reachable via WiFi
  static func isReachableViaWiFi(completed: @escaping (Bool) -> Void) {
      if (NetworkManager.shared.reachability).connection == .wifi {
        completed(true)
      } else {
        completed(false)
    }
  }
}

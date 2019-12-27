//
//  DiagnosticResponse.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import Foundation

class DiagnosticResponse: Codable {
  var id: String
  var estimatedTime: Int
  var device: DeviceResponse
  var status: String
  var results: [DiagnosticResults]?
}

class DiagnosticResults: Codable {
  var grade: String?
}

class ResultResponse: Codable {
  var diagnostic: DiagnosticResponse
}

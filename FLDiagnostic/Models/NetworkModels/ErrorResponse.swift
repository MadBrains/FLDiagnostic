//
//  ErrorResponse.swift
//  FLDiagnostic
//
//  Created by Данил on 27/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import Foundation

class ErrorResponse: Codable {
  var statusCode: Int?
  var message: String?
}

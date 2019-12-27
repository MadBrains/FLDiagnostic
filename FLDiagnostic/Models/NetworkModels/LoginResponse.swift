//
//  LoginResponse.swift
//  Forward Leasing
//
//  Created by Данил on 18/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import Foundation

class  LoginResponse: Codable {
  var accessToken: String
  var refreshToken: String
}

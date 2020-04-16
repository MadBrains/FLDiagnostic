//
//  DeviceResponse.swift
//  Forward Leasing
//
//  Created by Данил on 18/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import Foundation

class DeviceResponse: Codable {
  var id: String
  var model: DeviceModel?
  var imeis: [String]?
  var storageVolume: Int?
  var color: String?
}

class DeviceModel: Codable {
  var id: String
  var os: String
  var brand: String
  var name: String
  var version: String
  //var isUbgradable: Bool
  //var isTradable: Bool
  var tests: [Test]?
  var questions: [Question]?
}

class Test: Codable {
  var id: String
  var code: String
  var name: String
  var information: String?
  var canBeFailed: Bool
  var infoNeeded: Bool { return !(information?.isEmpty ?? true) }
  var isPassed: Bool?
  var timeSpent: Int?
  
  init() {
    self.id = ""
    self.code = ""
    self.name = ""
    self.canBeFailed = false
  }
}

class Question: Codable {
  var id: String
  var type: String
  var primaryText: String
  var secondaryText: String
  var answerEditName: String?
  var answerEditHint: String?
  var information: String?
  var answerRequired: Bool
  var affectsScore: Bool
  var minScore: Int?
  var maxScore: Int?
  var minNumber: Int?
  var maxNumber: Int?
  
  var isPassed: Bool?
  var answer: String?
  var timeSpent: Int?
  var gradeMapInterval: [GradeMapInterval]?
  var gradeMapBinary: [GradeMapBinary]?
  var infoNeeded: Bool { return !(information?.isEmpty ?? true) }
}

class GradeMapBinary: Codable {
  var value: Bool
  var grade: String
}

class GradeMapInterval: Codable {
  var grade: String
  var value: GradeMapIntervalValue
}

class GradeMapIntervalValue: Codable {
  //var to: Int?
  //var from: Int?
  var includeTo: Bool
  var includeFrom: Bool
}

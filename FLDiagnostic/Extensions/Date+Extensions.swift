//
//  Date+Extensions.swift
//  Forward Leasing
//
//  Created by Данил on 30/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import Foundation

extension Date {
  
  func addMinutes(minutes: Int) -> Date {
      return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
  }
  
}

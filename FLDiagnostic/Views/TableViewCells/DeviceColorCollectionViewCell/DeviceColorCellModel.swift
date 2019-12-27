//
//  DeviceColorCellModel.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class DeviceColorCellModel: BaseCellModel {
  var deviceColor: DeviceColor!
  var isSelected: Bool!
  
  init(deviceColor: DeviceColor, isSelected: Bool) {
    super.init(cellIdentifier: DeviceColorCollectionViewCell.cellIdentifier())
    self.deviceColor = deviceColor
    self.isSelected = isSelected
  }
}

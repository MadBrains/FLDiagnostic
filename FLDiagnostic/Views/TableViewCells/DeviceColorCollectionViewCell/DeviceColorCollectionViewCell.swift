//
//  DeviceColorCollectionViewCell.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

class DeviceColorCollectionViewCell: BaseCollectionViewCell {
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var checkImageView: UIImageView!
  
  override func configureCell(_ cellModel: BaseCellModel) {
    super.configureCell(cellModel)
    guard let model = cellModel as? DeviceColorCellModel else { return }
    
    checkImageView.image = UIImage.FLImage("ic_check_white").withRenderingMode(.alwaysTemplate)
    checkImageView.tintColor = model.deviceColor.checkTint
    checkImageView.isHidden = !model.isSelected
    
    containerView.backgroundColor = model.deviceColor.color
    containerView.layer.borderColor = model.deviceColor.borderColor.cgColor
    containerView.layer.borderWidth = 2
  }
}

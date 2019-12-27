//
//  UILabel+Extensions.swift
//  Forward Leasing
//
//  Created by Данил on 20/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
  
  public var textColor: Binder<UIColor> {
    return Binder(self.base) { label, color in
      label.textColor = color
    }
  }
  
}

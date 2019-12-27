//
//  SVProgressHUD+Extensions.swift
//  Forward Leasing
//
//  Created by Данил on 18/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxCocoa
import SVProgressHUD

extension Reactive where Base: SVProgressHUD {
  
  public static var isAnimating: Binder<Bool> {
    return Binder(UIApplication.shared) {progressHUD, isVisible in
      if isVisible {
        SVProgressHUD.show()
      } else {
        SVProgressHUD.dismiss()
      }
    }
  }
  
}

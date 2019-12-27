//
//  UITextField+Extensions.swift
//  Forward Leasing
//
//  Created by Данил on 23/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
  public var textChange: Observable<String?> {
      return Observable.merge(self.base.rx.observe(String.self, "text"),
                              self.base.rx.controlEvent(.editingChanged).withLatestFrom(self.base.rx.text))
  }
  
  public var placeholder: Binder<String> {
    return Binder(self.base) { textField, placeholder in
      textField.placeholder = placeholder
    }
  }
  
}

//
//  LoadingView.swift
//  Forward Leasing
//
//  Created by Kirirushi on 10.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxCocoa

class LoadingView: UIView {
  @IBOutlet private weak var animatableImageView: UIImageView!

  func startAnimating() {
      animatableImageView.startRotation()
  }

  func stopAnimating() {
      animatableImageView.stopRotation()
  }

}

extension Reactive where Base: LoadingView {
  
  var isAnimating: Binder<Bool> {
    return Binder(self.base) { loader, isVisible in
      if isVisible {
        loader.isHidden = false
        loader.startAnimating()
      } else {
        loader.isHidden = true
        loader.stopAnimating()
      }
    }
  }
  
}



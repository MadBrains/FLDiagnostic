//
//  TouchscreenTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 17.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class TouchscreenTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
    func startNextTest() {
      showNextTestViewController()
    }
}

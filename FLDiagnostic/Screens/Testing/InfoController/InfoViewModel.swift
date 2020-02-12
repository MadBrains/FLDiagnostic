//
//  InfoViewModel.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 17.01.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift

class InfoViewModel: BaseControllerViewModel {
  private var infoString: String
  var info = BehaviorSubject<NSAttributedString>(value: NSAttributedString())

  init(info: String) {
    infoString = info
    super.init()
  }

  override func setupModel() {
    super.setupModel()

    let infoAttributed = infoString.htmlToAttributedString
    infoAttributed.enumerateAttribute(.font, in: NSRange(location: 0, length: infoAttributed.length)) { (font, range, stop) in
      guard let font = font as? UIFont else { return }
      infoAttributed.removeAttribute(.font, range: range)
      infoAttributed.addAttribute(.font, value: UIFont.proximaNova(size: font.pointSize + 5, weight: .regular), range: range)
    }
    info.onNext(infoAttributed)
  }
}

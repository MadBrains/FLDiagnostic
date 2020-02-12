//
//  SoundTestViewModel.swift
//  Forward Leasing
//
//  Created by Kirirushi on 12.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import AVKit
import RxCocoa
import RxSwift
import UIKit

class SoundTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int

  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  private var player: AVAudioPlayer?

  func playSound() {
      stopSound()
      
      let path = Bundle.main.path(forResource: "testSound", ofType: "mp3")
      let url = URL(fileURLWithPath: path ?? "")

      player = try? AVAudioPlayer(contentsOf: url)
      player?.play()
  }

  func stopSound() {
      player?.stop()
      player = nil
  }
  
  func testFailed() {
      stopSound()
      abortDiagnostik()
  }

}

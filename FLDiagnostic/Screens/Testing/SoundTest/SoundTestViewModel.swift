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
import Mute

private let volumeNotificationName = "AVSystemController_SystemVolumeDidChangeNotification"
private let volumeParameter = "AVSystemController_AudioVolumeNotificationParameter"

class SoundTestViewModel: BaseControllerViewModel {
  var test: Test
  var page: Int
  let isAdviceHidden = BehaviorSubject<Bool>(value: true)
  
  private var popUpHidden: Bool = true
  private var volume: Float = 1.0
  private var isMute: Bool = false
  private var disposeBag = DisposeBag()
  
  init(_ test: Test, page: Int) {
    self.test = test
    self.page = page
    super.init()
  }
  
  private var player: AVAudioPlayer?

  override func setupModel() {
    super.setupModel()
    NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: volumeNotificationName)).subscribe(onNext: { [unowned self] (notification) in
      let volume = notification.userInfo![volumeParameter] as! Float
      self.volume = volume
      self.checkDeviceVolume()
    }).disposed(by: disposeBag)
    
    Mute.shared.checkInterval = 0
    Mute.shared.alwaysNotify = true
    Mute.shared.notify = { [unowned self] mute in
      self.isMute = mute
      self.checkDeviceVolume()
    }
  }
  
  func checkDeviceVolume() {
    isAdviceHidden.onNext(volume >= 0.5 && isMute == false)
  }
  func playSound() {
      stopSound()
      
      let path = Bundle.main.path(forResource: "testSound", ofType: "mp3")
      let url = URL(fileURLWithPath: path ?? "")

      player = try? AVAudioPlayer(contentsOf: url)
      player?.volume = 1
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

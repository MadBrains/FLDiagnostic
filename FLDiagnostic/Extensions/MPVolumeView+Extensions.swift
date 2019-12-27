//
//  MediaPlayer+Extension.swift
//  Forward Leasing
//
//  Created by Kirirushi on 05.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import MediaPlayer

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            slider?.value = volume
        }
    }
}

//
//  DrawerView+InteractionState.swift
//  MuseumGuide
//
//  Created by Alex on 29.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UltraDrawerView

extension DrawerView {
    enum InteractionState {
        case inactive, active
        
        var presentationType: State {
            switch self {
            case .inactive:
                return .bottom
            default:
                return .middle
            }
        }
    }
    
    var interactionState: InteractionState {
        get {
            if !self.headerView.isUserInteractionEnabled, !self.isUserInteractionEnabled {
                return .inactive
            } else {
                return .active
            }
        }
        
        set(state) {
            setState(state)
        }
    }
    
    func setState(_ state: InteractionState) {
        switch state {
        case .inactive:
            self.headerView.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = false
            headerView.showAnimatedGradientSkeleton()
            setState(.bottom, animated: true)
        case .active:
            self.headerView.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
            headerView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
        }
    }
}

//
//  InformationViewWorker.swift
//  MuseumGuide
//
//  Created by Alex on 29.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UltraDrawerView

class InformationViewWorker: PullingViewWorker {
    
    weak var handler: MapEventHandler?
    
    func drawerView(_ drawerView: DrawerView, willBeginUpdatingOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        
    }
    
    func drawerView(_ drawerView: DrawerView, didUpdateOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        
    }
    
    func drawerView(_ drawerView: DrawerView, didEndUpdatingOrigin origin: CGFloat, source: DrawerOriginChangeSource) {
        
    }
    
    func drawerView(_ drawerView: DrawerView, didChangeState state: DrawerView.State?) {
        
    }
    
    func drawerView(_ drawerView: DrawerView, willBeginAnimationToState state: DrawerView.State?, source: DrawerOriginChangeSource) {
        switch (state, source) {
        case (.bottom, .headerInteraction):
            handler?.deselectAnnotation()
        default:
            break
        }
    }
}

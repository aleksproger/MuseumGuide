//
//  ErrorHandling.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation


protocol ErrorHandling {
    func handleError(error: Error, handleTap: Closure<Bool>?)
}

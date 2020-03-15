//
//  VIPERRouter.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

protocol RouterProtocol: class {
    associatedtype ViewController: UIViewController
    var controller: ViewController! { get }
}

class VIPERRouter<U>: RouterProtocol where U: UIViewController {
    typealias ViewController = U
    weak var controller: ViewController!
    var errorHandler: ErrorHandling
    
    init(view: ViewController, errorHandler: ErrorHandling) {
        self.controller = view
        self.errorHandler = errorHandler
    }
    
}

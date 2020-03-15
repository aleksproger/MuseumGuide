//
//  ViewController.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, Loggable {
    var defaultLoggingTag: LogTag { .viewController }
    
    
    deinit {
        print("[D] \(self) destroyed")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log(.debug, "\(String(describing: self)) didLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log(.debug, "\(String(describing: self)) willAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}


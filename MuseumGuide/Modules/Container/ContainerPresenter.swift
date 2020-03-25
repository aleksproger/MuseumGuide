//
//  ContainerPresenter.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

class ContainerPresenter: ContainerEventHandler {
    weak var view: ContainerViewBehavior!
    var router: ContainerRouter
    let networkService = NetworkManager()
    private var subscriptions = Set<AnyCancellable>()

    
    init(view: ContainerViewBehavior, router: ContainerRouter) {
        self.view = view
        self.router = router
        networkService.getRandomBeer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    break
                case .finished:
                    break
                }
            }, receiveValue: { beer in
                print(beer)
            }).store(in: &subscriptions)
    }

    
    func handleTap() {
        //openMap()
    }
}


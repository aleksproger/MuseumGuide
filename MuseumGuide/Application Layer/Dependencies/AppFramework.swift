//
//  AppFramework.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import DITranquillity

public class AppFramework: DIFramework {
    public static func load(container: DIContainer) {
        container.append(part: ControllersPart.self)
    }
}

private class ControllersPart: DIPart {
    static let parts: [DIPart.Type] =
        [ MapPart.self,
          ContainerPart.self ]
    static func load(container: DIContainer) {
            parts.forEach { part in
                container.append(part: part)
        }
    }
}

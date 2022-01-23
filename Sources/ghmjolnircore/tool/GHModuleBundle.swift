//
//  GHModuleBundle.swift
//  ghmjolnircore
//
//  Created by Javier Carapia on 23/01/22.
//

import class Foundation.Bundle

public struct GHModuleBundle {
    public static func getBundle(bundleName: String, classFind: AnyClass) -> Bundle {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: classFind.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName.appending(".bundle"))
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        fatalError("unable to find bundle named smloginapi_smloginapi")
    }
}

//
//  File.swift
//  
//
//  Created by Javier Carapia on 14/02/22.
//

import UIKit

public protocol GHModelTableSectionDelegate {
    var titleSection: String? { get set }
    var listSection: [GHModelSimpleTableDelegate]? { get set }
}

//
//  File.swift
//  
//
//  Created by Javier Carapia on 14/02/22.
//

public protocol GHModelTableSectionDelegate {
    var titleSection: String? { get set }
    var listSection: [GHModelTableDelegate]? { get set }
}

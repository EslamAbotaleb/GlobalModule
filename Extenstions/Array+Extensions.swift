//
//  Array+Extensions.swift
//  CERQEL
//
//  Created by Eslam on 06/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

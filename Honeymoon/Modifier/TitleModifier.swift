//
//  TitleModifier.swift
//  Honeymoon
//
//  Created by wizz on 12/11/21.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.pink)
    }
}



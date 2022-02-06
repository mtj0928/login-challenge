//
//  ReloadButton.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import SwiftUI

struct ReloadButton: View {

    let action: () async -> Void

    var body: some View {
        AsyncButton(action: action) {
            Image(systemName: "arrow.clockwise")
        }
    }
}

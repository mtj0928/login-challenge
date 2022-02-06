//
//  AsyncButton.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import SwiftUI

struct AsyncButton<Label>: View where Label: View {

    let action: () async -> Void
    let label: () -> Label

    var body: some View {
        Button(
            action: { Task { await action() } },
            label: label
        )
    }
}

extension AsyncButton where Label == Text {

    init(text: String, action: @escaping () async -> Void) {
        self.init(action: action, label: {
            Text(text)
        })
    }
}

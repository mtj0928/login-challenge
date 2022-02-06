//
//  UserProfileView.swift
//  
//
//  Created by Junnosuke Matsumoto on 2022/02/06.
//

import SwiftUI
import Entities

struct UserProfileView: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: 10) {
            personImage
                .frame(width: 120, height: 120)

            VStack(spacing: 0) {
                userName
                userID
            }

            introductionText
        }
    }

    private var personImage: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .foregroundColor(Color(uiColor: .systemGray4))
    }

    private var userName: some View {
        Text(user?.name ?? Placeholder.name)
            .font(.title3)
            .redacted(reason: user?.name == nil ? .placeholder : [])
    }

    private var userID: some View {
        let id = user?.id.rawValue ?? Placeholder.introduction
        let idWithAtMark = "@\(id)"
        return Text(idWithAtMark)
            .font(.body)
            .foregroundColor(Color(UIColor.systemGray))
            .redacted(reason: user?.id == nil ? .placeholder : [])
    }

    private var introductionText: some View {
        introductionText(user?.introduction ?? Placeholder.introduction)
            .font(.body)
            .redacted(reason: user?.introduction == nil ? .placeholder : [])
    }

    @ViewBuilder
    private func introductionText(_ text: String) -> some View {
        if let attributedIntroduction = try? AttributedString(markdown: text) {
            Text(attributedIntroduction)
        } else {
            Text(text)
        }
    }
}

extension UserProfileView {

    enum Placeholder {
        static let name = "User Name"
        static let id = "ididid"
        static let introduction = "Introduction. Introduction. Introduction. Introduction. Introduction. Introduction."
    }
}

//
//  ProfileHeaderView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    let currentUser: User
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray.opacity(0.3))
                    .background(Circle().fill(Color.orange.opacity(0.1)))
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.orange)
                    .background(Circle().fill(.white))
                    .offset(x: -2, y: -2)
            }
            
            VStack(spacing: 4) {
                Text(currentUser.userName)
                    .font(.title2.bold())
                Text(currentUser.userBio)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

#Preview {
    let previewUser = User(
        id: "1",
        userName: "Kaizz",
        email: "kaizz@example.com",
        userBio: "Hello World",
        followers: 100,
        likes: 500
    )

    ProfileHeaderView(currentUser: previewUser)
}

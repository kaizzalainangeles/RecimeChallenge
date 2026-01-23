//
//  InstructionStepRowView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

struct InstructionStepRowView: View {
    let index: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text("\(index + 1)")
                .font(.title3.bold())
                .foregroundColor(.orange)
                .frame(width: 32, height: 32)
                .background(Color.orange.opacity(0.1))
                .clipShape(Circle())
            
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    InstructionStepRowView(index: 1, text: "Cook")
}

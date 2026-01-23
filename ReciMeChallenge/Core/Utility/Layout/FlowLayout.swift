//
//  FlowLayout.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

struct FlowLayout: Layout {
    var alignment: Alignment = .leading
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = result.points[index]
            subview.place(at: CGPoint(x: point.x + bounds.minX, y: point.y + bounds.minY), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, points: [CGPoint]) {
        var maxWidth: CGFloat = 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxHeightInRow: CGFloat = 0
        var points: [CGPoint] = []
        
        let proposalWidth = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > proposalWidth {
                maxWidth = max(maxWidth, currentX)
                currentX = 0
                currentY += maxHeightInRow + spacing
                maxHeightInRow = 0
            }

            points.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            maxHeightInRow = max(maxHeightInRow, size.height)
        }

        return (CGSize(width: max(maxWidth, currentX), height: currentY + maxHeightInRow), points)
    }
}


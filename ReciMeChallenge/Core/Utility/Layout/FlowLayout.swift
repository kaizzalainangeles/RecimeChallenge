//
//  FlowLayout.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

/// A custom layout that arranges subviews in a line and wraps them to the next row
/// when the available width is exceeded.
/// Used for filter tags.
struct FlowLayout: Layout {
    var alignment: Alignment = .leading
    var spacing: CGFloat = 8

    /// Tells SwiftUI how much space this layout needs based on its subviews.
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    /// Assigns specific positions (coordinates) to each subview within the layout's bounds.
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = result.points[index]
            subview.place(at: CGPoint(x: point.x + bounds.minX, y: point.y + bounds.minY), proposal: .unspecified)
        }
    }

    /// The main logic that calculates where each item should go and the total size of the container.
    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, points: [CGPoint]) {
        var maxWidth: CGFloat = 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxHeightInRow: CGFloat = 0
        var points: [CGPoint] = []
        
        // Use the width provided by the parent view (or infinity if not constrained)
        let proposalWidth = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            // Check if adding this subview would exceed the row width
            if currentX + size.width > proposalWidth {
                maxWidth = max(maxWidth, currentX)
                currentX = 0
                currentY += maxHeightInRow + spacing
                maxHeightInRow = 0
            }

            // Record the position for this subview
            points.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            maxHeightInRow = max(maxHeightInRow, size.height)
        }

        return (CGSize(width: max(maxWidth, currentX), height: currentY + maxHeightInRow), points)
    }
}


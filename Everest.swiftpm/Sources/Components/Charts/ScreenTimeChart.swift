//
//  ScreenTimePlaceholderView.swift
//  Everest
//
//  Created by Ethan Leonard on 1/16/26.
//

import SwiftUI

struct ScreenTimePlaceholderView: View {
    // Exact colors from main app / extension
    private let brandColor = Color(.sRGB, red: 0x4A/255, green: 0x7C/255, blue: 0x59/255)
    private let textPrimary = Color(.sRGB, red: 0x2D/255, green: 0x2D/255, blue: 0x2D/255)
    private let textSecondary = Color(.sRGB, red: 0x6B/255, green: 0x72/255, blue: 0x80/255)
    private let cardBg = Color(.sRGB, red: 0xF5/255, green: 0xF5/255, blue: 0xF5/255)
    private let strokeColor = Color(.sRGB, red: 0xE2/255, green: 0xE2/255, blue: 0xE2/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            
            // Static demo chart area
            HStack(alignment: .bottom, spacing: 16) {
                ForEach(0..<7, id: \.self) { index in
                    VStack(spacing: 8) {
                        let barHeight: CGFloat = [120, 110, 95, 105, 80, 70, 65][index]
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(index >= 5 ? brandColor : brandColor.opacity(0.4))
                            .frame(width: 24, height: barHeight)
                        
                        Text(["M", "T", "W", "T", "F", "S", "S"][index])
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(textSecondary)
                    }
                }
            }
            .frame(height: 160, alignment: .bottom)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.85))
                
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(strokeColor.opacity(0.6), lineWidth: 1)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.10), radius: 2, x: 0, y: 1)
        .shadow(color: .black.opacity(0.10), radius: 3, x: 0, y: 1)
        .padding(.horizontal, 4) // Match TotalActivityView padding (applied outside background)
    }
    
    private var headerView: some View {
        HStack {
            Circle()
                .fill(cardBg)
                .frame(width: 32, height: 32)
                .overlay {
                    Image(systemName: "hourglass")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(textPrimary)
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Screen Time")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(textPrimary)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("5h 12m")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(textPrimary)
                    
                    Text("Daily Average")
                        .font(.caption)
                        .foregroundStyle(textSecondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "ellipsis")
                .foregroundStyle(textSecondary)
                .frame(width: 44, height: 44)
        }
        .padding([.horizontal, .top], 16)
    }
}

#Preview {
    ZStack {
        Color.gray
        ScreenTimePlaceholderView()
            .padding()
    }
}

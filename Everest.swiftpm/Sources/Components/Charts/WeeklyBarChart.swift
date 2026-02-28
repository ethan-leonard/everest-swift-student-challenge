import SwiftUI
import Charts

// MARK: - Weekly Bar Chart
struct WeeklyBarChart: View {
    enum TimeRange: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        
        var id: String { rawValue }
    }
    
    let dailyCounts: [Int]
    let title: String
    let subtitle: String
    @Binding var selectedRange: TimeRange
    
    var showHeader: Bool = true
    var showBackground: Bool = true
    
    @State private var selectedIndex: Int?
    
    private var labels: [String] {
        switch selectedRange {
        case .week: return ["M", "T", "W", "T", "F", "S", "S"]
        case .month: return ["W1", "W2", "W3", "W4"]
        case .year: return ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
        }
    }
    
    private var data: [(label: String, count: Int)] {
        zip(labels, dailyCounts).map { ($0, $1) }
    }
    
    private var maxCount: Int {
        max(dailyCounts.max() ?? 1, 1)
    }
    
    var body: some View {
        Group {
            if showBackground {
                content
                    .padding(16)
                    .glassCardStyle()
            } else {
                content
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            if showHeader {
                headerView
            }
            barChartView
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Circle()
                .fill(Color.appCardBackground)
                .frame(width: 32, height: 32)
                .overlay {
                    Image(systemName: "book.fill")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.appTextPrimary)
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appTextPrimary)
                
                if let selectedIndex, selectedIndex < data.count {
                    let count = data[selectedIndex].count
                    Text("\(count) \(count == 1 ? "Lesson" : "Lessons")")
                        .font(.caption)
                        .foregroundStyle(Color.appBrand)
                        .contentTransition(.numericText())
                } else {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.appTextSecondary)
                }
            }
            
            Spacer()
            
            Menu {
                ForEach(TimeRange.allCases) { range in
                    Button {
                        selectedRange = range
                        selectedIndex = nil
                    } label: {
                        HStack {
                            Text(range.rawValue)
                            if selectedRange == range {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                .foregroundStyle(Color.appTextSecondary)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
            }
        }
    }
    
    private var barChartView: some View {
        let isYearView = data.count > 10
        let spacing: CGFloat = isYearView ? 6 : 12
        let barWidth: CGFloat = isYearView ? 16 : 28
        
        return HStack(alignment: .bottom, spacing: spacing) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                VStack(spacing: 8) {
                    ZStack(alignment: .bottom) {
                        Capsule()
                            .fill(Color(hex: "E5E5EA").opacity(0.5))
                            .frame(height: 100)
                        
                        if item.count > 0 {
                            Capsule()
                                .fill(Color.appBrand)
                                .frame(height: max(12, CGFloat(item.count) / CGFloat(maxCount) * 100))
                        }
                    }
                    .frame(width: barWidth)
                    .opacity(selectedIndex == nil || selectedIndex == index ? 1.0 : 0.3)
                    
                    Text(item.label)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(selectedIndex == index ? Color.appBrand : Color.appTextSecondary)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(duration: 0.3)) {
                        selectedIndex = selectedIndex == index ? nil : index
                    }
                }
            }
        }
        .frame(height: 140)
        .drawingGroup() // Optimize rendering performance
    }
    
    // MARK: - Time Range Picker
    struct TimeRangePicker: View {
        @Binding var selection: TimeRange
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(TimeRange.allCases) { range in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selection = range
                        }
                    } label: {
                        Text(range.rawValue.prefix(1)) // "W", "M", "Y"
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(selection == range ? .white : Color.appTextSecondary)
                            .frame(width: 32, height: 32)
                            .background(
                                Group {
                                    if selection == range {
                                        Circle().fill(Color.appBrand)
                                            .matchedGeometryEffect(id: "picker", in: animation)
                                    }
                                }
                            )
                            .contentShape(Circle())
                    }
                }
            }
            .padding(4)
            .background(Color.appCardBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
            )
        }
        
        @Namespace private var animation
    }
}

#Preview {
    WeeklyBarChart(
        dailyCounts: [2, 1, 3, 2, 1, 4, 0],
        title: "Knowledge Growth",
        subtitle: "Lessons completed this week",
        selectedRange: .constant(.week)
    )
    .padding()
}

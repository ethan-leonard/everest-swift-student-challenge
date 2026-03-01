import SwiftUI
import Charts

struct ScreenTimeChartView: View {
    enum TimeRange: String, CaseIterable, Identifiable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        case year = "Year"

        var id: String { rawValue }
    }

    let hourlyMinutes: [Int]
    let totalMinutes: Int
    let formattedTime: String
    let weekMinutes: [Int]
    let monthMinutes: [Int]
    let yearMinutes: [Int]

    @State private var selectedRange: TimeRange = .day
    @State private var selectedX: Double?
    @State private var selectedMinutes: Int?

    // Exact colors from main app
    private let brandColor = Color(.sRGB, red: 0x4A/255, green: 0x7C/255, blue: 0x59/255)
    private let textPrimary = Color(.sRGB, red: 0x2D/255, green: 0x2D/255, blue: 0x2D/255)
    private let textSecondary = Color(.sRGB, red: 0x6B/255, green: 0x72/255, blue: 0x80/255)
    private let cardBg = Color(.sRGB, red: 0xF5/255, green: 0xF5/255, blue: 0xF5/255)
    private let strokeColor = Color(.sRGB, red: 0xE2/255, green: 0xE2/255, blue: 0xE2/255)

    private var activeData: [Int] {
        switch selectedRange {
        case .day: return hourlyMinutes
        case .week: return weekMinutes
        case .month: return monthMinutes
        case .year: return yearMinutes
        }
    }

    private var chartData: [(index: Double, minutes: Double)] {
        activeData.enumerated().map { (Double($0.offset), Double($0.element)) }
    }

    private var axisLabels: [String] {
        switch selectedRange {
        case .day: return ["12AM", "8AM", "4PM", "12AM"]
        case .week: return ["M", "T", "W", "T", "F", "S", "S"]
        case .month: return ["W1", "W2", "W3", "W4"]
        case .year: return ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
        }
    }

    private var chartMin: Double { 0 }
    private var chartMax: Double { (activeData.max().map(Double.init) ?? 100) * 1.1 }

    private var chartGradient: LinearGradient {
        LinearGradient(
            colors: [brandColor.opacity(0.15), brandColor.opacity(0.01)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var isEmpty: Bool {
        activeData.allSatisfy { $0 == 0 }
    }

    private var subtitle: String {
        if let selectedMinutes {
            return "\(selectedMinutes / 60)h \(selectedMinutes % 60)m"
        }
        return formattedTime
    }

    var body: some View {
        content
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
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView

            ZStack(alignment: .bottom) {
                if isEmpty {
                    emptyStateView
                } else {
                    chartView
                        .animation(.easeInOut(duration: 0.35), value: selectedRange)
                }

                if !isEmpty {
                    axisLabelsView
                }
            }
            .frame(height: 160)
            .clipped()
        }
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

                if let selectedMinutes {
                    Text("\(selectedMinutes / 60)h \(selectedMinutes % 60)m")
                        .font(.caption)
                        .foregroundStyle(brandColor)
                        .contentTransition(.numericText())
                } else {
                    Text(formattedTime)
                        .font(.caption)
                        .foregroundStyle(textSecondary)
                }
            }

            Spacer()

            Menu {
                ForEach(TimeRange.allCases) { range in
                    Button {
                        selectedRange = range
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
                    .foregroundStyle(textSecondary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
        }
        .padding([.horizontal, .top], 16)
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 32))
                .foregroundStyle(textSecondary.opacity(0.4))

            Text("No data yet")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(textSecondary)

            Text("Screen time will appear here as you use the app")
                .font(.system(size: 13))
                .foregroundStyle(textSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
    }

    private var axisLabelsView: some View {
        HStack {
            if !axisLabels.isEmpty {
                Text(axisLabels.first ?? "")

                Spacer()

                if axisLabels.count > 3 {
                    if axisLabels.count >= 7 {
                        ForEach(1..<(axisLabels.count-1), id: \.self) { i in
                            Text(axisLabels[i])
                            Spacer()
                        }
                    } else {
                        Text(axisLabels[1])
                        Spacer()
                        Text(axisLabels[2])
                        Spacer()
                    }
                } else {
                    ForEach(1..<(axisLabels.count-1), id: \.self) { i in
                        Text(axisLabels[i])
                        Spacer()
                    }
                }

                Text(axisLabels.last ?? "")
            }
        }
        .font(.system(size: 10, weight: .medium))
        .foregroundStyle(textSecondary)
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    private var chartView: some View {
        Chart {
            chartContent
            scrubbingIndicator
        }
        .chartXScale(domain: 0...Double(max(1, activeData.count - 1)))
        .chartYScale(domain: chartMin...chartMax)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .drawingGroup()
        .chartOverlay { proxy in
            GeometryReader { _ in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                guard let xValue: Double = proxy.value(atX: value.location.x) else { return }
                                let clampedX = max(0, min(Double(activeData.count - 1), xValue))
                                let lowerIndex = Int(floor(clampedX))
                                let upperIndex = min(Int(ceil(clampedX)), activeData.count - 1)
                                let fraction = clampedX - Double(lowerIndex)
                                let lowerValue = Double(activeData[lowerIndex])
                                let upperValue = Double(activeData[upperIndex])
                                let interpolatedY = lowerValue + (upperValue - lowerValue) * fraction
                                selectedX = clampedX
                                selectedMinutes = Int(interpolatedY)
                            }
                            .onEnded { _ in
                                withAnimation(.easeOut(duration: 0.2)) {
                                    selectedX = nil
                                    selectedMinutes = nil
                                }
                            }
                    )
            }
        }
    }

    @ChartContentBuilder
    private var chartContent: some ChartContent {
        ForEach(chartData, id: \.index) { item in
            AreaMark(
                x: .value("Time", item.index),
                yStart: .value("Base", chartMin),
                yEnd: .value("Minutes", item.minutes)
            )
            .interpolationMethod(.linear)
            .foregroundStyle(chartGradient)

            LineMark(
                x: .value("Time", item.index),
                y: .value("Minutes", item.minutes)
            )
            .interpolationMethod(.linear)
            .foregroundStyle(brandColor)
            .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
    }

    @ChartContentBuilder
    private var scrubbingIndicator: some ChartContent {
        if let selectedX, let selectedMinutes {
            RuleMark(x: .value("Time", selectedX))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundStyle(textSecondary.opacity(0.5))

            PointMark(
                x: .value("Time", selectedX),
                y: .value("Minutes", Double(selectedMinutes))
            )
            .foregroundStyle(brandColor)
            .symbolSize(100)
        }
    }
}

#Preview {
    ScreenTimeChartView(
        hourlyMinutes: [5, 2, 0, 0, 0, 8, 15, 20, 10, 5, 3, 2, 8, 12, 15, 10, 8, 5, 3, 2, 1, 0, 0, 0],
        totalMinutes: 312,
        formattedTime: "5h 12m Daily Average",
        weekMinutes: [120, 95, 83, 110, 75, 45, 30],
        monthMinutes: Array(repeating: 90, count: 30),
        yearMinutes: [2800, 2600, 2400, 2700, 2500, 2300, 2100, 2000, 2200, 2400, 2600, 83]
    )
    .padding()
}

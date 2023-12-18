//
//  Home.swift
//  InteractiveChart
//
//  Created by Denys Nazymok on 16.12.2023.
//
import Charts
import SwiftUI

struct Home: View {
    // View Properties
    @State private var graphType: GraphType = .donut
    // Propertie for bar selection
    @State private var barSelection: String?
    @State private var pieSelection: Double?
    var appDownloads: [AppDownload] {
        AppDownload.example.sorted(by: { graphType == .bar ? false : $0.downloads > $1.downloads })
    }
    
    var body: some View {
        VStack {
            // Segmented Picker
            Picker("Select graph view", selection: $graphType) {
                ForEach(GraphType.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            
            if let highestDownloads = AppDownload.example.max(by: {
                $1.downloads > $0.downloads
            }) {
                if graphType == .bar {
                    ChartPopOverView(highestDownloads.day, highestDownloads.downloads, true)
                        .padding([.vertical])
                        .opacity(barSelection == nil ? 1 : 0)
                } else {
                    if let barSelection, let pieSelection = appDownloads.findDownloads(barSelection) {
                        ChartPopOverView(barSelection, pieSelection, true, true)
                    } else {
                        ChartPopOverView(highestDownloads.day, highestDownloads.downloads, true)
                    }
                }
            }
            
            // Charts
            Chart {
                ForEach(appDownloads) { download in
                    if graphType == .bar {
                        // Bar Chart
                        BarMark(
                            x: .value("Day", download.day),
                            y: .value("Downloads", download.downloads)
                        )
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Days", download.day))
                    } else {
                        // Pie and Donut Chart
                        SectorMark(
                            angle: .value("Downloads", download.downloads),
                            innerRadius: .ratio(graphType == .donut ? 0.61 : 0),
                            angularInset: graphType == .donut ? 6 : 1
                        )
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Days", download.day))
                        .opacity(barSelection == nil ? 1 : (barSelection == download.day ? 1 : 0.4))
                    }
                }
                
                if let barSelection {
                    RuleMark(x: .value("Day", barSelection))
                        .foregroundStyle(.gray.opacity(0.35))
                        .zIndex(-10)
                        .offset(yStart: -10)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(x: .fit, y: .disabled)
                        ) {
                            if let downloads = AppDownload.example.findDownloads(barSelection) {
                                ChartPopOverView(barSelection, downloads, false)
                            }
                        }
                }
            }
            .chartXSelection(value: $barSelection)
            .chartAngleSelection(value: $pieSelection)
            .chartLegend(position: .bottom, alignment: graphType == .bar ? .leading : .center, spacing: 25)
            .frame(height: 300)
            .padding(.top, 15)
            // Adding animation
            .animation(graphType == .bar ? .none : .snappy, value: graphType)
            
            Spacer(minLength: 0)
        }
        .padding()
        .onChange(of: pieSelection, initial: false) { oldValue, newValue in
            if let newValue {
                findDownload(newValue)
            } else {
                barSelection = nil
            }
        }
    }
    // Chart PopOver View
    @ViewBuilder
    func ChartPopOverView(_ day: String, _ downloads: Double, _ isTitleView: Bool = false, _ isSelection: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(isTitleView && !isSelection ? "Highest" :  "App") Downloads")
                .font(.title3)
                .foregroundStyle(.gray)
            HStack(spacing: 4) {
                Text(String(format: "%.2f", downloads))
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(day)
                    .font(.title3)
                    .textScale(.secondary)
            }
        }
        .padding(isTitleView ? [.horizontal] : [.all])
        .background(.yellow.opacity(isTitleView ? 0 : 1), in: .rect(cornerRadius: 8))
        .frame(maxWidth: .infinity, alignment: isTitleView ? .leading : .center)
    }
    // Converting download model into array of tuples
    func findDownload(_ rangeValue: Double) {
        var initialValue = 0.0
        let convertedArray = appDownloads.compactMap { download -> (String, Range<Double>) in
            let endRange = initialValue + download.downloads
            let tuple = (download.day, initialValue..<endRange)
        // Updating initial value
            initialValue = endRange
            return tuple
        }
        
        if let download = convertedArray.first(where: {
            $0.1.contains(rangeValue)
        }) {
            barSelection = download.0
        }
    }
}

#Preview {
    Home()
}

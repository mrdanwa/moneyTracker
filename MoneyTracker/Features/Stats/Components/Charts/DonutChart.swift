//DonutChart.swift
//Donut chart visualization
//struct DonutChartView: View

import SwiftUI
import Charts

// MARK: - Donut Chart
struct DonutChartView: View {
    let data: [(String, Double, Color)]
    
    /// Computes the total of all category amounts.
    private var total: Double {
        data.reduce(0) { $0 + $1.1 }
    }
    
    var body: some View {
        Canvas { context, size in
            let donutWidth: CGFloat = 40
            let radius = min(size.width, size.height) / 2 - donutWidth / 2
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            
            var startAngle = Angle.degrees(-90)
            
            for (_, value, color) in data {
                let angleValue = value / total * 360
                let endAngle = startAngle + Angle.degrees(angleValue)
                
                let path = Path { p in
                    p.addArc(center: center, radius: radius,
                             startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.addArc(center: center, radius: radius - donutWidth,
                             startAngle: endAngle, endAngle: startAngle, clockwise: true)
                    p.closeSubpath()
                }
                
                context.fill(path, with: .color(color))
                startAngle = endAngle
            }
        }
    }
}

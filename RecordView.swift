//
//  RecordView.swift
//  TimeTrailSwiftui
//
//  Created by MacBook on 17.08.2024.
//

import Foundation
import SwiftUI

/// View для отображения одной записи в списке
struct RecordView: View {
    var record: Record
    var isSelected: Bool
    var onLongPress: () -> Void

    @State private var timeElapsed: String = ""
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }

                Text(record.text)
                    .lineLimit(isExpanded ? nil : 1)
                    .foregroundColor(.white)
                    .onTapGesture {
                        if record.text.count > 20 {
                            isExpanded.toggle()
                        }
                    }

                Spacer()

                Text(timeElapsed)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(8)
        .onAppear(perform: updateTimeElapsed)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateTimeElapsed()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }

    /// Обновление времени, прошедшего с момента старта записи
    private func updateTimeElapsed() {
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(record.startTime)

        let days = Int(elapsedTime / 86400)
        let hours = Int((elapsedTime.truncatingRemainder(dividingBy: 86400)) / 3600)
        let minutes = Int((elapsedTime.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))

        timeElapsed = "\(days)Д \(hours)Ч \(minutes)М \(seconds)С"
    }
}

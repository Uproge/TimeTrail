//
//  ContentView.swift
//  TimeTrailSwiftui
//
//  Created by MacBook on 17.08.2024.
//

import SwiftUI

/// Главный view для отображения списка записей
struct ContentView: View {
    @State private var records: [Record] = [] {
        didSet {
            saveRecords() // Сохранение записей при каждом изменении списка
        }
    }
    @State private var showingAddRecordView = false
    @State private var selectedRecords: Set<UUID> = []

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(records) { record in
                        RecordView(
                            record: record,
                            isSelected: selectedRecords.contains(record.id),
                            onLongPress: {
                                if selectedRecords.contains(record.id) {
                                    selectedRecords.remove(record.id)
                                } else {
                                    selectedRecords.insert(record.id)
                                }
                            }
                        )
                        .listRowInsets(EdgeInsets())
                        .background(Color.black)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.black)
            }
            .navigationBarTitle("Записи", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    showingAddRecordView = true
                }) {
                    Image(systemName: "plus")
                },
                trailing: HStack {
                    Button(action: {
                        updateSelectedRecords()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(selectedRecords.isEmpty)
                    
                    Button(action: {
                        deleteSelectedRecords()
                    }) {
                        Image(systemName: selectedRecords.isEmpty ? "trash" : "trash.fill")
                    }
                    .disabled(selectedRecords.isEmpty)
                }
            )
            .sheet(isPresented: $showingAddRecordView) {
                AddRecordView { newRecord in
                    records.append(newRecord)
                }
            }
            .onAppear(perform: loadRecords) // Загрузка записей при запуске приложения
        }
    }
    
    /// Сброс времени у выбранных записей на текущий момент
    private func updateSelectedRecords() {
        for id in selectedRecords {
            if let index = records.firstIndex(where: { $0.id == id }) {
                records[index].startTime = Date() // Сброс времени на текущее
            }
        }
        selectedRecords.removeAll()
        saveRecords() // Сохранение изменений после сброса времени
    }
    
    /// Удаление выбранных записей
    private func deleteSelectedRecords() {
        records.removeAll { selectedRecords.contains($0.id) }
        selectedRecords.removeAll()
        saveRecords() // Сохранение изменений после удаления записей
    }

    /// Сохранение записей в UserDefaults
    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "records")
        }
    }

    /// Загрузка записей из UserDefaults
    private func loadRecords() {
        if let savedRecords = UserDefaults.standard.data(forKey: "records"),
           let decodedRecords = try? JSONDecoder().decode([Record].self, from: savedRecords) {
            records = decodedRecords
        }
    }
}

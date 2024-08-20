//
//  AddRecordView.swift
//  TimeTrailSwiftui
//
//  Created by MacBook on 17.08.2024.
//

import Foundation
import SwiftUI

/// View для создания новой записи.
struct AddRecordView: View {
    @State private var recordText: String = ""
    @State private var selectedDate = Date()
    @Environment(\.presentationMode) var presentationMode
    var onSave: (Record) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Параметры записи")) {
                    TextField("Введите текст", text: $recordText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    // Ограничение выбора даты и времени до текущего момента
                    DatePicker("Выбор даты", selection: $selectedDate, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                        .environment(\.locale, Locale(identifier: "ru_RU")) // Устанавливаем русскую локализацию
                }

                Section {
                    Button(action: {
                        // Проверка на наличие текста в записи
                        guard !recordText.isEmpty else { return }

                        // Создание новой записи с указанной датой
                        let newRecord = Record(text: recordText, startTime: selectedDate)
                        onSave(newRecord)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Сохранить")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationBarTitle("Новая запись", displayMode: .inline)
            .navigationBarItems(trailing: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

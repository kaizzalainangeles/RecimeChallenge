//
//  RecipeCreateView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI
import PhotosUI

struct RecipeCreateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: RecipeCreateViewModel
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                // SECTION 1: IMAGE
                Section {
                    imagePickerHeader
                }
                .listRowInsets(EdgeInsets()) // Makes image flush with edges
                .listRowBackground(Color.clear)
                
                // SECTION 2: BASIC INFO
                Section("Basic Details") {
                    TextField("Recipe Title", text: $viewModel.title)
                        .font(.headline)
                    
                    Stepper(value: $viewModel.servings, in: 1...20) {
                        Label("Servings: \(viewModel.servings)", systemImage: "person.2")
                    }
                    
                    TextField("Short Description", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                // SECTION 3: DIETARY INFO
                Section("Dietary Info") {
                    ForEach(DietaryFilter.allCases, id: \.self) { filter in
                        Toggle(filter.rawValue, isOn: Binding(
                            get: { viewModel.selectedDietary.contains(filter) },
                            set: { isSelected in
                                if isSelected { viewModel.selectedDietary.insert(filter) }
                                else { viewModel.selectedDietary.remove(filter) }
                            }
                        ))
                        .tint(.orange)
                    }
                }
                
                // SECTION 4: INGREDIENTS
                Section {
                    ForEach($viewModel.ingredients) { $ingredient in
                        HStack {
                            TextField("Qty", text: $ingredient.quantity)
                                .frame(width: 60)
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                            
                            Divider()
                            
                            TextField("Ingredient name", text: $ingredient.name)
                        }
                    }
                    .onDelete { viewModel.ingredients.remove(atOffsets: $0) }
                    
                    Button {
                        withAnimation {
                            viewModel.ingredients.append(Ingredient(name: "", quantity: ""))
                        }
                    } label: {
                        Label("Add Ingredient", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Ingredients")
                }
                
                // SECTION 4: INSTRUCTIONS
                Section("Instructions") {
                    ForEach(viewModel.instructions.indices, id: \.self) { index in
                        HStack(alignment: .top) {
                            Text("\(index + 1)")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Circle().fill(Color.orange))
                                .padding(.top, 2)
                            
                            TextField("Step detail", text: $viewModel.instructions[index], axis: .vertical)
                        }
                    }
                    .onDelete { viewModel.instructions.remove(atOffsets: $0) }
                    
                    Button {
                        withAnimation { viewModel.instructions.append("") }
                    } label: {
                        Label("Add Step", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .fontWeight(.bold)
                    .disabled(viewModel.title.isEmpty)
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var imagePickerHeader: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack {
                if let data = viewModel.selectedImageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 30))
                        Text("Add Cover Photo")
                            .font(.subheadline.bold())
                    }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.05))
                    .foregroundColor(.orange)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.orange.opacity(0.2), style: StrokeStyle(lineWidth: 2, dash: [5]))
                    )
                }
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        viewModel.selectedImageData = data
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func saveRecipe() {
        viewModel.save()
        dismiss()
    }
}

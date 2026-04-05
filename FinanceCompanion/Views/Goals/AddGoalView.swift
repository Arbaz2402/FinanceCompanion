import SwiftUI
import SwiftData

struct AddGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = AddGoalViewModel()
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isTargetFocused: Bool
    @FocusState private var isCurrentFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                    .onTapGesture { dismissKeyboard() }
                
                ScrollView {
                    VStack(spacing: 24) {
                        AddGoalHeader()
                        
                        AddGoalForm(
                            viewModel: viewModel,
                            isTitleFocused: $isTitleFocused,
                            isTargetFocused: $isTargetFocused,
                            isCurrentFocused: $isCurrentFocused
                        )
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Create Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { 
                        viewModel.save(context: modelContext)
                        HapticManager.notification(type: .success)
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                    .fontWeight(.bold)
                }
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                    Button("Done") { dismissKeyboard() }
                }
            }
        }
    }
    
    private func dismissKeyboard() {
        isTitleFocused = false
        isTargetFocused = false
        isCurrentFocused = false
    }
}

// MARK: - Subviews

private struct AddGoalHeader: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 120, height: 120)
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundStyle(.blue.gradient)
        }
        .padding(.top, 20)
    }
}

private struct AddGoalForm: View {
    @Bindable var viewModel: AddGoalViewModel
    var isTitleFocused: FocusState<Bool>.Binding
    var isTargetFocused: FocusState<Bool>.Binding
    var isCurrentFocused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Goal Name Section
            VStack(alignment: .leading, spacing: 8) {
                Text("What are you saving for?")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                TextField("e.g. Dream Vacation, New MacBook", text: $viewModel.title)
                    .font(.title3.bold())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .secondarySystemGroupedBackground)))
                    .focused(isTitleFocused)
            }
            
            // Amount Section
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Target (₹)")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                    
                    TextField("0", value: $viewModel.targetAmount, format: .number)
                        .font(.title3.bold())
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .secondarySystemGroupedBackground)))
                        .focused(isTargetFocused)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Starting (₹)")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                    
                    TextField("0", value: $viewModel.currentAmount, format: .number)
                        .font(.title3.bold())
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .secondarySystemGroupedBackground)))
                        .focused(isCurrentFocused)
                }
            }
            
            // Timeline Section
            VStack(alignment: .leading, spacing: 12) {
                Toggle(isOn: $viewModel.hasDeadline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Set a Deadline")
                            .font(.headline)
                        Text("Plan your savings timeline")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(.blue)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .secondarySystemGroupedBackground)))
                
                if viewModel.hasDeadline {
                    DatePicker("Target Date", selection: $viewModel.deadline, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .secondarySystemGroupedBackground)))
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddGoalView()
        .modelContainer(previewContainer)
}

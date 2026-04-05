import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: AddTransactionViewModel
    @FocusState private var isAmountFocused: Bool
    @FocusState private var isNotesFocused: Bool
    
    init(transaction: Transaction? = nil) {
        _viewModel = State(initialValue: AddTransactionViewModel(transaction: transaction))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                    .onTapGesture { dismissKeyboard() }
                
                VStack(spacing: 0) {
                    AddTransactionHeader(
                        amount: $viewModel.amount,
                        type: viewModel.type,
                        isFocused: $isAmountFocused
                    )
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            AddTransactionForm(
                                type: $viewModel.type,
                                category: $viewModel.category,
                                date: $viewModel.date,
                                notes: $viewModel.notes,
                                isNotesFocused: $isNotesFocused
                            )
                        }
                        .padding(.top, 10)
                        .onTapGesture { dismissKeyboard() }
                    }
                }
            }
            .navigationTitle(viewModel.isValid ? "Edit Entry" : "New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { 
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
        isAmountFocused = false
        isNotesFocused = false
    }
}

// MARK: - Subviews

private struct AddTransactionHeader: View {
    @Binding var amount: String
    let type: TransactionType
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(spacing: 16) {
            Text(type == .income ? "Income Amount" : "Expense Amount")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            HStack(alignment: .center, spacing: 8) {
                Text("₹")
                    .font(.system(size: 32, weight: .bold))
                
                TextField("0", text: $amount)
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .focused(isFocused)
                    .fixedSize(horizontal: true, vertical: true)
                    .onChange(of: amount) { _, newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue { amount = filtered }
                    }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(type == .income ? .green : .red)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 10)
        )
        .padding()
    }
}

private struct AddTransactionForm: View {
    @Binding var type: TransactionType
    @Binding var category: TransactionCategory
    @Binding var date: Date
    @Binding var notes: String
    var isNotesFocused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(spacing: 24) {
            Picker("Type", selection: $type) {
                ForEach(TransactionType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Select Category")
                    .font(.headline)
                    .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                    ForEach(TransactionCategory.allCases, id: \.self) { cat in
                        CategoryChip(category: cat, isSelected: category == cat) {
                            withAnimation(.spring()) {
                                category = cat
                                HapticManager.selection()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            VStack(spacing: 16) {
                DatePicker("Transaction Date", selection: $date, displayedComponents: .date)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .secondarySystemGroupedBackground)))
                
                TextField("Add a note...", text: $notes, axis: .vertical)
                    .lineLimit(2...4)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .secondarySystemGroupedBackground)))
                    .focused(isNotesFocused)
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryChip: View {
    let category: TransactionCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? category.color : category.color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    Image(systemName: category.icon)
                        .foregroundStyle(isSelected ? .white : category.color)
                        .font(.title3)
                }
                Text(category.rawValue)
                    .font(.caption.bold())
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
            .frame(width: 80)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color(uiColor: .secondarySystemGroupedBackground) : Color.clear)
                    .shadow(color: isSelected ? .black.opacity(0.05) : .clear, radius: 5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddTransactionView()
        .modelContainer(previewContainer)
}

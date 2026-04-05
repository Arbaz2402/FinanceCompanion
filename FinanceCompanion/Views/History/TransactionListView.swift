import SwiftUI
import SwiftData

struct TransactionListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @State private var showingAddTransaction = false
    @State private var editingTransaction: Transaction?
    @State private var viewModel = TransactionViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TransactionFilterSection(viewModel: viewModel)
                
                TransactionListSection(
                    transactions: viewModel.filteredTransactions,
                    onDelete: { transaction in
                        modelContext.delete(transaction)
                    },
                    onEdit: { transaction in
                        editingTransaction = transaction
                    }
                )
            }
            .navigationTitle("History")
            .searchable(text: $viewModel.searchText, prompt: "Search notes or categories")
            .toolbar {
                Button {
                    showingAddTransaction.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
            .sheet(item: $editingTransaction) { transaction in
                AddTransactionView(transaction: transaction)
            }
            .onAppear {
                withAnimation {
                    viewModel.update(transactions: transactions)
                }
            }
            .onChange(of: transactions) { _, newTransactions in
                withAnimation {
                    viewModel.update(transactions: newTransactions)
                }
            }
        }
    }
}

// MARK: - Subviews

private struct TransactionFilterSection: View {
    @Bindable var viewModel: TransactionViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Picker("Type", selection: $viewModel.selectedType) {
                Text("All").tag(nil as TransactionType?)
                ForEach(TransactionType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type as TransactionType?)
                }
            }
            .pickerStyle(.segmented)
            
            HStack(spacing: 12) {
                // Month Picker
                Menu {
                    Button("All Months") {
                        withAnimation { viewModel.selectedMonth = nil }
                    }
                    ForEach(viewModel.availableMonths, id: \.self) { month in
                        Button(month.formatted(.dateTime.month(.wide).year())) {
                            withAnimation { 
                                viewModel.selectedMonth = month 
                                viewModel.selectedDate = nil
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "calendar")
                        Text(viewModel.selectedMonth?.formatted(.dateTime.month().year()) ?? "All Months")
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .font(.subheadline.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(viewModel.selectedMonth != nil ? Color.blue : Color.gray.opacity(0.1))
                    .foregroundStyle(viewModel.selectedMonth != nil ? .white : .primary)
                    .cornerRadius(10)
                }
                
                // Date Picker
                DatePicker("", selection: Binding(
                    get: { viewModel.selectedDate ?? Date() },
                    set: { viewModel.selectedDate = $0; viewModel.selectedMonth = nil }
                ), displayedComponents: .date)
                .labelsHidden()
                .scaleEffect(0.9)
                
                if viewModel.selectedDate != nil || viewModel.selectedMonth != nil {
                    Button {
                        withAnimation {
                            viewModel.selectedDate = nil
                            viewModel.selectedMonth = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }
}

private struct TransactionListSection: View {
    let transactions: [Transaction]
    let onDelete: (Transaction) -> Void
    let onEdit: (Transaction) -> Void
    
    var body: some View {
        List {
            if transactions.isEmpty {
                AppEmptyStateView(
                    icon: "list.bullet.rectangle.portrait",
                    title: "No Transactions",
                    description: "Try adjusting your filters or add a new transaction."
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            } else {
                ForEach(transactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                withAnimation {
                                    onDelete(transaction)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                onEdit(transaction)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                }
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(transaction.category.color.opacity(0.1))
                    .frame(width: 48, height: 48)
                Image(systemName: transaction.category.icon)
                    .foregroundStyle(transaction.category.color)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category.rawValue)
                    .font(.headline)
                    .fontWeight(.bold)
                if !transaction.notes.isEmpty {
                    Text(transaction.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.amount, format: .currency(code: "INR"))
                    .font(.headline)
                    .foregroundStyle(transaction.type == .income ? .green : .primary)
                    .fontWeight(.bold)
                Text(transaction.date, format: .dateTime.month().day())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TransactionListView()
        .modelContainer(previewContainer)
}

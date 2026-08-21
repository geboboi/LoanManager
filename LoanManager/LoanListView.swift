//
//  LoanListView.swift
//  LoanManager
//
//  Created by Gabriela on 21/08/26.
//

import SwiftUI

struct LoanListView: View {
    @StateObject private var viewModel = LoanViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.loans.isEmpty {
                    ProgressView("Fetching Loans...")
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text(error).foregroundColor(.red).multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.fetchLoans() }
                        }
                    }
                } else {
                    List(viewModel.filteredAndSortedLoans) { loan in
                        NavigationLink(destination: LoanDetailView(loan: loan)) {
                            LoanRowView(loan: loan)
                        }
                    }
                    // Additional Feature: Pull-to-refresh
                    .refreshable {
                        await viewModel.fetchLoans()
                    }
                }
            }
            .navigationTitle("Loan Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort By", selection: $viewModel.sortOption) {
                            ForEach(LoanViewModel.SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .task {
                if viewModel.loans.isEmpty {
                    await viewModel.fetchLoans()
                }
            }
        }
    }
}

struct LoanRowView: View {
    let loan: Loan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(loan.borrower.name)
                .font(.headline)
            
            HStack {
                Text("Amount: $\(loan.amount, specifier: "%.2f")")
                Spacer()
                Text("Rate: \(loan.interestRate, specifier: "%.1f")%")
            }
            .font(.subheadline)
            
            HStack {
                Text("Term: \(loan.term) months")
                Spacer()
                Text("Purpose: \(loan.purpose)")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Text("Risk Rating: \(loan.riskRating)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(loan.riskRating == "High" ? .red : .green)
        }
        .padding(.vertical, 4)
    }
}


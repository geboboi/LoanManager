//
//  LoanDetailView.swift
//  LoanManager
//
//  Created by Gabriela on 21/08/26.
//

import SwiftUI

struct LoanDetailView: View {
    let loan: Loan
    @ObservedObject var viewModel: LoanViewModel
    
    var body: some View {
        List {
            Section(header: Text("Borrower Information")) {
                DetailRow(title: "Name", value: loan.borrower.name)
                DetailRow(title: "Email", value: loan.borrower.email)
                DetailRow(title: "Credit Score", value: "\(loan.borrower.creditScore)")
            }
            
            Section(header: Text("Collateral Details")) {
                DetailRow(title: "Type", value: loan.collateral.type)
                DetailRow(title: "Value", value: "$\(loan.collateral.value, default: "%.2f")")
            }

            Section(header: Text("Repayment Schedule")) {
                let installments = loan.repaymentSchedule?.installments ?? []
                
                if installments.isEmpty {
                    Text("No repayment schedule available.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(installments) { item in
                        HStack {
                            Text(item.dueDate)
                            Spacer()
                            Text("$\(item.amountDue, specifier: "%.2f")")
                        }
                    }
                }
            }
            
            Section(header: Text("Loan Documents")) {
                let docs = loan.documents ?? []
                
                if docs.isEmpty {
                    Text("No documents available.")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(docs) { document in
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.blue)
                            Text(document.type)
                            Spacer()
                            
                            if let validURL = viewModel.getFullDocumentURL(from: document.url) {
                                Link("View", destination: validURL)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Loan Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title).foregroundColor(.secondary)
            Spacer()
            Text(value).bold()
        }
    }
}


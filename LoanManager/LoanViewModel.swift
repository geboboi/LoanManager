//
//  LoanViewModel.swift
//  LoanManager
//
//  Created by Gabriela on 21/08/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class LoanViewModel: ObservableObject {
    @Published var loans: [Loan] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    enum SortOption: String, CaseIterable {
        case none = "None"
        case amount = "Amount"
        case term = "Term"
        case purpose = "Purpose"
    }
    
    @Published var sortOption: SortOption = .none
    
    var filteredAndSortedLoans: [Loan] {
        var result = loans
        switch sortOption {
        case .amount:
            result.sort { $0.amount > $1.amount }
        case .term:
            result.sort { $0.term > $1.term }
        case .purpose:
            result.sort { $0.purpose < $1.purpose }
        case .none:
            break
        }
        return result
    }
    
    func fetchLoans() async {
        isLoading = true
        errorMessage = nil
        
        let endpointString = "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main/api/json/loans.json"
        guard let url = URL(string: endpointString) else {
            errorMessage = "Invalid API URL."
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            self.loans = try decoder.decode([Loan].self, from: data)
        } catch {
            self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func getFullDocumentURL(from relativePath: String) -> URL? {
        if relativePath.hasPrefix("http") {
            return URL(string: relativePath)
        } else {
            let baseURL = "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main"
            return URL(string: baseURL + relativePath)
        }
    }
}

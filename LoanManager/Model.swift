//
//  Model.swift
//  LoanManager
//
//  Created by Gabriela on 21/08/26.
//

import Foundation

struct Loan: Codable, Identifiable {
    let id: String
    let amount: Double
    let interestRate: Double
    let term: Int
    let purpose: String
    let riskRating: String
    let borrower: Borrower
    let collateral: Collateral
    let documents: [LoanDocument]?
    let repaymentSchedule: RepaymentSchedule?
}

struct Borrower: Codable {
    let id: String
    let name: String
    let email: String
    let creditScore: Int
}

struct Collateral: Codable {
    let type: String
    let value: Double
}

struct LoanDocument: Codable, Identifiable {
    var id: String { url }
    let type: String
    let url: String
}

struct RepaymentSchedule: Codable {
    let installments: [Installment]
}

struct Installment: Codable, Identifiable {
    var id: String { dueDate }
    let dueDate: String
    let amountDue: Double
}

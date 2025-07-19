//
//  Course.swift
//  StudyFit
//

import Foundation

// MARK: - 인강 모델
struct Course: Identifiable, Codable, Hashable{
    let id: String
    let title: String
    let instructor: String
    
}


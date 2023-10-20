//
//  Process.swift
//  process-viewer
//
//  Created by jerr-it on 10/15/23.
//

import Foundation

struct Process: Hashable, Identifiable {
    var pid: Int
    var user: String
    var cmd: String
    
    var pcpu: Double
    var pmem: Double

    var id = UUID()
}

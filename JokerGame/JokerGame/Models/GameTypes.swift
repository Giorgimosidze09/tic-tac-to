import Foundation

public enum GameMode: String, CaseIterable {
    case standard = "Standard (8-9-8-9)"
    case nines = "All Nines (4x4)"
}

public enum KhisthiMode: String, CaseIterable {
    case speci = "Speci"
    case fixed200 = " -200"
    case fixed500 = " -500"
} 
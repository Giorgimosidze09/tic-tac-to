import SwiftUI
import Charts

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.3)
    static let jokerRed = Color(red: 0.8, green: 0.2, blue: 0.2)
    static let jokerGreen = Color(red: 0.2, green: 0.6, blue: 0.3)
}

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var showMainContent = false
    @Binding var showSplash: Bool
    @ObservedObject var game: Game
    
    var body: some View {
        ZStack {
            Color.jokerRed
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "suit.spade.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                
                Text("Joker")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
            }
        }
        .onAppear {
            game.playBackgroundMusic()
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showMainContent = true
                }
            }
        }
        .opacity(showMainContent ? 0 : 1)
        .onChange(of: showMainContent) { newValue in
            if newValue {
                game.stopBackgroundMusic()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSplash = false
                }
            }
        }
    }
}

private struct LanguageSection: View {
    @ObservedObject var game: Game
    @Binding var selectedLanguage: Game.Language
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Language", selection: $selectedLanguage) {
                ForEach(Game.Language.allCases, id: \.self) { language in
                    Text(language.rawValue).tag(language)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private struct ThemeSection: View {
    @ObservedObject var game: Game
    @Binding var selectedTheme: AppTheme
    @Environment(\.colorScheme) var colorScheme
    
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    private var cardBackgroundColor: Color {
        isDarkMode ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    private var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(game.localizedString("theme"))
                .font(.headline)
                .foregroundColor(textColor)
            
            Picker("Theme", selection: $selectedTheme) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Text(game.localizedString(theme.rawValue.lowercased()))
                        .tag(theme)
                        .foregroundColor(textColor)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(cardBackgroundColor)
            .cornerRadius(8)
        }
    }
}

private struct GameModeSection: View {
    @ObservedObject var game: Game
    @Binding var selectedGameMode: Game.GameMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Game Mode", selection: $selectedGameMode) {
                ForEach(Game.GameMode.allCases, id: \.self) { mode in
                    Text(game.localizedString(mode.rawValue))
                        .tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text(game.getGameModeDescription(selectedGameMode))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
    }
}

private struct KhisthiModeSection: View {
    @ObservedObject var game: Game
    @Binding var selectedKhisthi: Game.KhisthiMode
    
    private var khisthiModeDescription: String {
        switch selectedKhisthi {
        case .speci:
            return game.localizedString("speciModeDescription")
        case .fixed200:
            return game.localizedString("fixed200ModeDescription")
        case .fixed500:
            return game.localizedString("fixed500ModeDescription")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Khisthi Mode", selection: $selectedKhisthi) {
                ForEach(Game.KhisthiMode.allCases, id: \.self) { mode in
                    Text(game.localizedString(mode.rawValue.lowercased()))
                        .tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text(khisthiModeDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
    }
}

private struct GameRulesSection: View {
    @ObservedObject var game: Game
    
    private var gameRules: String {
        game.localizedString("gameRulesDescription")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(gameRules)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

private struct ViewStyleSection: View {
    @ObservedObject var game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("View Style", selection: $game.viewStyle) {
                ForEach(Game.ViewStyle.allCases, id: \.self) { style in
                    Text(game.localizedString(style.rawValue))
                        .tag(style)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text(game.localizedString("\(game.viewStyle.rawValue)ViewDescription"))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
    }
}

struct SettingsView: View {
    @Binding var selectedTheme: AppTheme
    @Binding var selectedGameMode: Game.GameMode
    @Binding var selectedKhisthi: Game.KhisthiMode
    @ObservedObject var game: Game
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var lastSystemTheme: ColorScheme?
    
    private var currentTheme: ColorScheme {
        if let theme = selectedTheme.colorScheme {
            return theme
        }
        return colorScheme
    }
    
    private var isDarkMode: Bool {
        currentTheme == .dark
    }
    
    private var cardBackgroundColor: Color {
        isDarkMode ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    private var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    private var gameModeDescription: String {
        switch selectedGameMode {
        case .standard:
            return game.localizedString("standardModeDescription")
        case .nines:
            return game.localizedString("ninesModeDescription")
        }
    }
    
    private var khisthiModeDescription: String {
        switch selectedKhisthi {
        case .speci:
            return game.localizedString("speciModeDescription")
        case .fixed200:
            return game.localizedString("fixed200ModeDescription")
        case .fixed500:
            return game.localizedString("fixed500ModeDescription")
        }
    }
    
    private var gameRules: String {
        game.localizedString("gameRulesDescription")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // View Style Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(game.localizedString("viewStyle"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ViewStyleSection(game: game)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(cardBackgroundColor)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Language Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(game.localizedString("language"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            LanguageSection(game: game, selectedLanguage: $game.selectedLanguage)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(cardBackgroundColor)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Theme Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(game.localizedString("appearance"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ThemeSection(game: game, selectedTheme: $selectedTheme)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(cardBackgroundColor)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Game Mode Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(game.localizedString("gameMode"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            GameModeSection(game: game, selectedGameMode: $selectedGameMode)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(cardBackgroundColor)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Khisthi Mode Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(game.localizedString("khisthiMode"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            KhisthiModeSection(game: game, selectedKhisthi: $selectedKhisthi)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(cardBackgroundColor)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    
                    // Game Rules Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(game.localizedString("gameRules"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            GameRulesSection(game: game)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(cardBackgroundColor)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                }
                .padding()
            }
            .navigationTitle(game.localizedString("settings"))
            .navigationBarItems(trailing: Button(game.localizedString("done")) {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .preferredColorScheme(currentTheme)
        .onChange(of: colorScheme) { newValue in
            if selectedTheme == .system {
                withAnimation {
                    lastSystemTheme = newValue
                    game.objectWillChange.send()
                }
            }
        }
        .onAppear {
            lastSystemTheme = colorScheme
        }
    }
}

struct UndoView: View {
    @ObservedObject var game: Game
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRound: Int
    @State private var playerUpdates: [UUID: (bid: Int?, tricks: Int?)] = [:]
    @State private var errorMessage: String? = nil
    @State private var showingError = false
    
    init(game: Game) {
        self.game = game
        _selectedRound = State(initialValue: game.currentRound - 1)
    }
    
    private var roundData: [(player: Game.Player, bid: Int, tricks: Int)] {
        game.getRoundBidsAndTakes(round: selectedRound)
    }
    
    private func updatePlayer(playerId: UUID, bid: Int?, tricks: Int?) {
        playerUpdates[playerId] = (bid: bid, tricks: tricks)
    }
    
    private func validateUpdates() -> Bool {
        // Get the number of cards for the round being undone
        let cardsDealt = selectedRound
        var totalBids = 0
        var totalTricks = 0
        
        // Calculate total bids and tricks
        for player in game.players {
            let bid = playerUpdates[player.id]?.bid ?? roundData.first(where: { $0.player.id == player.id })?.bid ?? -1
            let tricks = playerUpdates[player.id]?.tricks ?? roundData.first(where: { $0.player.id == player.id })?.tricks ?? -1
            
            if bid != -1 {
                totalBids += bid
            }
            
            if tricks != -1 {
                totalTricks += tricks
            }
        }
        
        // Check if total tricks exceed cards dealt
        if totalTricks > cardsDealt {
            errorMessage = game.localizedString("totalTricksExceedCards")
            return false
        }
        
        // Check if total tricks are less than cards dealt
        if totalTricks < cardsDealt {
            errorMessage = game.localizedString("totalTricksLessThanCards")
            return false
        }
        
        // No need to validate individual bids as they can exceed cards dealt
        
        return true
    }
    
    private func applyChanges() {
        if !validateUpdates() {
            showingError = true
            return
        }
        
        let updates = playerUpdates.map { (playerId: UUID, values: (bid: Int?, tricks: Int?)) in
            (playerId: playerId, bid: values.bid, tricks: values.tricks)
        }
        game.updateRoundBidsAndTakes(round: selectedRound, updates: updates)
        game.applyUndoChanges()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Round Picker
                Picker("Round", selection: $selectedRound) {
                    ForEach(1..<game.currentRound, id: \.self) { round in
                        Text("\(game.localizedString("round")) \(round)")
                            .tag(round)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Players Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(roundData, id: \.player.id) { data in
                            VStack(spacing: 8) {
                                Text(data.player.name)
                                    .font(.headline)
                                    .foregroundColor(data.player.isDealer ? .jokerRed : .primary)
                                
                                HStack {
                                    // Bid Section
                                    VStack {
                                        Text(game.localizedString("bid"))
                                            .font(.caption)
                                        TextField("Bid", value: Binding(
                                            get: { playerUpdates[data.player.id]?.bid ?? data.bid },
                                            set: { updatePlayer(playerId: data.player.id, bid: $0, tricks: playerUpdates[data.player.id]?.tricks) }
                                        ), formatter: NumberFormatter())
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(width: 60)
                                    }
                                    
                                    Spacer()
                                    
                                    // Tricks Section
                                    VStack {
                                        Text(game.localizedString("tricks"))
                                            .font(.caption)
                                        TextField("Tricks", value: Binding(
                                            get: { playerUpdates[data.player.id]?.tricks ?? data.tricks },
                                            set: { updatePlayer(playerId: data.player.id, bid: playerUpdates[data.player.id]?.bid, tricks: $0) }
                                        ), formatter: NumberFormatter())
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(width: 60)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                
                // Apply Button
                Button(action: applyChanges) {
                    Text(game.localizedString("applyChanges"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle(game.localizedString("undoRound"))
            .navigationBarItems(trailing: Button(game.localizedString("cancel")) {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingError) {
                Alert(
                    title: Text(game.localizedString("error")),
                    message: Text(errorMessage ?? ""),
                    dismissButton: .default(Text(game.localizedString("ok")))
                )
            }
        }
    }
}

struct GameView: View {
    @StateObject private var game = Game()
    @State private var playerNames: [String] = Array(repeating: "", count: 4)
    @State private var showingGame = false
    @State private var showingRoundScores = false
    @State private var selectedRound = 1
    @State private var selectedPlayer: Game.Player?
    @State private var showingFinalScores = false
    @State private var selectedGameMode: Game.GameMode = .standard
    @State private var selectedKhisthi: Game.KhisthiMode = .speci
    @State private var showSplash = true
    @State private var selectedTheme: AppTheme = {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = AppTheme(rawValue: savedTheme) {
            return theme
        }
        return .system
    }()
    @Environment(\.colorScheme) var colorScheme
    @State private var showingSettings = false
    @State private var lastSystemTheme: ColorScheme?
    @State private var showingUndoView = false
    @State private var keyboardHeight: CGFloat = 0
    
    private var currentTheme: ColorScheme {
        if let theme = selectedTheme.colorScheme {
            return theme
        }
        return colorScheme
    }
    
    private var isDarkMode: Bool {
        currentTheme == .dark
    }
    
    private var backgroundColor: Color {
        isDarkMode ? Color(.systemBackground) : Color(.systemBackground)
    }
    
    private var cardBackgroundColor: Color {
        isDarkMode ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    private var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    private func formatScore(_ score: Int) -> String {
        if score == 0 {
            return "0.0"
        }
        let absScore = abs(score)
        let wholePart = absScore / 100
        let decimalPart = (absScore % 100) / 10
        let formattedScore = "\(wholePart).\(decimalPart)"
        return score < 0 ? "-\(formattedScore)" : formattedScore
    }
    
    private var winner: Game.Player? {
        guard game.isGameComplete else { return nil }
        return game.players.max(by: { $0.score < $1.score })
    }
    
    private var currentPlayer: Game.Player? {
        if let nextBidder = game.getNextBidder() {
            return nextBidder
        } else if let nextTaker = game.getNextTaker() {
            return nextTaker
        }
        return nil
    }
    
    private var availableNumbers: [Int] {
        guard let player = currentPlayer else { return [] }
        
        if !game.isBiddingComplete && player.currentBid == -1 {
            // Always return all numbers from 0 to cards in round
            return Array(0...game.cardsInRound())
        } else if game.isBiddingComplete && player.currentTricks == -1 {
            let otherPlayersTricks = game.players
                .filter { $0.id != player.id }
                .reduce(0) { $0 + ($1.currentTricks == -1 ? 0 : $1.currentTricks) }
            let remainingTricks = game.cardsInRound() - otherPlayersTricks
            
            // If this is the last player and others have taken some cards,
            // they must take the remaining cards
            if remainingTricks > 0 && game.players.filter({ $0.currentTricks == -1 }).count == 1 {
                return [remainingTricks]
            }
            
            return remainingTricks >= 0 ? Array(0...remainingTricks) : []
        }
        return []
    }
    
    private func isBidValid(_ bid: Int) -> Bool {
        guard let player = currentPlayer, player.isDealer else { return true }
        let otherPlayersBids = game.players
            .filter { $0.id != player.id }
            .reduce(0) { $0 + ($1.currentBid == -1 ? 0 : $1.currentBid) }
        return bid + otherPlayersBids != game.cardsInRound()
    }
    
    private var inputTitle: String {
        guard let player = currentPlayer else { return "" }
        if !game.isBiddingComplete && player.currentBid == -1 {
            return "\(player.name)'s Bid"
        } else if game.isBiddingComplete && player.currentTricks == -1 {
            return "\(player.name)'s Take"
        }
        return ""
    }
    
    private func handleNumberSelection(_ number: Int) {
        guard let player = currentPlayer else { return }
        if !game.isBiddingComplete && player.currentBid == -1 {
            game.setBid(for: player, bid: number)
        } else if game.isBiddingComplete && player.currentTricks == -1 {
            let otherPlayersTricks = game.players
                .filter { $0.id != player.id }
                .reduce(0) { $0 + ($1.currentTricks == -1 ? 0 : $1.currentTricks) }
            let remainingTricks = game.cardsInRound() - otherPlayersTricks
            
            // If this is the last player and others have taken some cards,
            // they must take the remaining cards
            if remainingTricks > 0 && game.players.filter({ $0.currentTricks == -1 }).count == 1 {
                game.setTricks(for: player, tricks: remainingTricks)
            } else {
                game.setTricks(for: player, tricks: number)
            }
        }
    }
    
    private var numberKeyboard: some View {
        VStack(spacing: 0) {
            Text("\(currentPlayer?.name ?? "")'s \(game.isBiddingComplete ? game.localizedString("tricks") : game.localizedString("bid"))")
                .font(.caption)
                .padding(.vertical, 2)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 0) {
                ForEach(availableNumbers, id: \.self) { number in
                    let isValid = !game.isBiddingComplete && currentPlayer?.isDealer == true ? 
                        isBidValid(number) : true
                    
                    Button(action: { 
                        if isValid {
                            handleNumberSelection(number)
                        }
                    }) {
                        Text("\(number)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(isValid ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                            .background(isValid ? Color.blue : Color.gray.opacity(0.3))
                    }
                    .disabled(!isValid)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(6)
        .shadow(radius: 1)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
    }
    
    private var finalScoresView: some View {
        VStack(spacing: 15) {
            Text(game.isGameComplete ? game.localizedString("finalScores") : game.localizedString("currentScores"))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            ForEach(game.players.sorted(by: { $0.score > $1.score })) { player in
                HStack {
                    Text(player.name)
                        .font(.headline)
                    Spacer()
                    Text(formatScore(player.score))
                        .font(.title2)
                        .foregroundColor(player.id == winner?.id ? .green : .primary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(player.id == winner?.id ? Color.gold.opacity(0.2) : Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(player.id == winner?.id ? Color.gold : Color.clear, lineWidth: 2)
                )
            }
            
            if !game.isGameComplete {
                Text("\(game.localizedString("gameIncomplete")) - \(game.currentRound) \(game.localizedString("roundsPlayed"))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            
            Button(action: {
                showingFinalScores = false
                game.resetGame()
            }) {
                Text(game.localizedString("returnHome"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var roundScoresView: some View {
        VStack(spacing: 15) {
            Text("\(game.localizedString("round")) \(selectedRound) \(game.localizedString("scores"))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            if let scores = game.getRoundScores(round: selectedRound) {
                ForEach(Array(zip(game.players.indices, scores)), id: \.0) { index, score in
                    HStack {
                        Text(game.players[index].name)
                            .font(.headline)
                        Spacer()
                        Text(formatScore(score))
                            .font(.title2)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                }
            }
            
            Button(action: {
                showingRoundScores = false
            }) {
                Text(game.localizedString("done"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen(showSplash: $showSplash, game: game)
            } else {
                NavigationView {
                    if !game.isGameSetup {
                        // Player Setup View
                        ScrollView {
                            VStack(spacing: 20) {
                                Text("Joker Game")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.jokerRed)
                                    .padding(.top, 20)
                                
                                ForEach(0..<4) { index in
                                    TextField("\(game.localizedString("player")) \(index + 1)", text: $playerNames[index])
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.horizontal)
                                }
                                
                                Button(action: {
                                    for name in playerNames {
                                        if !name.isEmpty {
                                            game.addPlayer(name: name)
                                        }
                                    }
                                    game.gameMode = selectedGameMode
                                    game.khisthiMode = selectedKhisthi
                                    game.startGame()
                                    showingGame = true
                                }) {
                                    Text(game.localizedString("startGame"))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal)
                                .disabled(playerNames.contains(""))
                                
                                Button(action: {
                                    showingSettings = true
                                }) {
                                    HStack {
                                        Image(systemName: "gear")
                                        Text(game.localizedString("settings"))
                                    }
                                    .font(.headline)
                                    .foregroundColor(.jokerRed)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.jokerRed.opacity(0.1))
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal)
                            }
                            .padding()
                            .background(backgroundColor)
                        }
                        .preferredColorScheme(currentTheme)
                        .background(backgroundColor)
                        .sheet(isPresented: $showingSettings) {
                            SettingsView(
                                selectedTheme: $selectedTheme,
                                selectedGameMode: $selectedGameMode,
                                selectedKhisthi: $selectedKhisthi,
                                game: game
                            )
                        }
                    } else {
                        // Main Game View - Switch between Standard and Improved views
                        Group {
                            if game.viewStyle == .standard {
                                StandardGameView(
                                    game: game,
                                    showingFinalScores: $showingFinalScores,
                                    showingUndoView: $showingUndoView
                                )
                                .forceLandscape()
                                .navigationBarHidden(true)
                            } else {
                                // Existing improved view layout
                                ZStack {
                                    ScrollView {
                                        VStack(spacing: 15) {
                                            // Round Info Card
                                            RoundInfoView(game: game)
                                                .padding(.horizontal)
                                            
                                            // Players Grid
                                            LazyVGrid(columns: [
                                                GridItem(.flexible()),
                                                GridItem(.flexible())
                                            ], spacing: 15) {
                                                ForEach(game.players) { player in
                                                    PlayerView(player: player, game: game)
                                                        .transition(.scale.combined(with: .opacity))
                                                        .animation(.spring(), value: player.currentBid)
                                                        .animation(.spring(), value: player.currentTricks)
                                                }
                                            }
                                            .padding(.horizontal)
                                            
                                            // Action Buttons
                                            VStack(spacing: 10) {
                                                if game.isRoundComplete {
                                                    Button(action: {
                                                        game.startRound()
                                                    }) {
                                                        Text(game.localizedString("nextRound"))
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                            .frame(maxWidth: .infinity)
                                                            .padding()
                                                            .background(Color.blue)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    showingUndoView = true
                                                }) {
                                                    Text(game.localizedString("undo"))
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity)
                                                        .padding()
                                                        .background(Color.orange)
                                                        .cornerRadius(10)
                                                }
                                                
                                                Button(action: {
                                                    showingFinalScores = true
                                                }) {
                                                    Text(game.isGameComplete ? game.localizedString("showFinalScores") : game.localizedString("returnHome"))
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity)
                                                        .padding()
                                                        .background(game.isGameComplete ? Color.green : Color.blue)
                                                        .cornerRadius(10)
                                                }
                                            }
                                            .padding(.horizontal)
                                            .padding(.top, 10)
                                            .padding(.bottom, 20)
                                        }
                                        .padding(.vertical)
                                        .padding(.bottom, !availableNumbers.isEmpty ? 300 : 0)
                                    }
                                    
                                    // Keyboard overlay
                                    if !availableNumbers.isEmpty {
                                        VStack {
                                            Spacer()
                                            numberKeyboard
                                                .padding(.bottom, 20)
                                        }
                                        .frame(maxHeight: .infinity, alignment: .bottom)
                                        .ignoresSafeArea(.keyboard)
                                    }
                                }
                                .onAppear {
                                    // Reset to portrait when showing improved view
                                    AppDelegate.orientationLock = .all
                                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                    UINavigationController.attemptRotationToDeviceOrientation()
                                }
                            }
                        }
                        .navigationTitle("Joker Game")
                        .sheet(isPresented: $showingFinalScores) {
                            finalScoresView
                        }
                        .sheet(isPresented: $showingUndoView) {
                            UndoView(game: game)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(currentTheme)
        .onChange(of: colorScheme) { newValue in
            if selectedTheme == .system {
                withAnimation {
                    lastSystemTheme = newValue
                    game.objectWillChange.send()
                }
            }
        }
        .onChange(of: selectedTheme) { newValue in
            withAnimation {
                UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
                game.objectWillChange.send()
            }
        }
        .onAppear {
            lastSystemTheme = colorScheme
        }
    }
}

struct PlayerView: View {
    let player: Game.Player
    @ObservedObject var game: Game
    @Environment(\.colorScheme) var colorScheme
    
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    private var cardBackgroundColor: Color {
        isDarkMode ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    private var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    private func formatScore(_ score: Int) -> String {
        if score == 0 {
            return "0.0"
        }
        let absScore = abs(score)
        let wholePart = absScore / 100
        let decimalPart = (absScore % 100) / 10
        let formattedScore = "\(wholePart).\(decimalPart)"
        return score < 0 ? "-\(formattedScore)" : formattedScore
    }
    
    var isNextToBid: Bool {
        guard let nextBidder = game.getNextBidder() else { return false }
        return nextBidder.id == player.id
    }
    
    var isNextToTake: Bool {
        guard let nextTaker = game.getNextTaker() else { return false }
        return nextTaker.id == player.id
    }
    
    var bidStatus: String {
        if game.isBiddingComplete {
            return "\(game.localizedString("bid")): \(player.currentBid == -1 ? "Not set" : String(player.currentBid))"
        } else if isNextToBid {
            return game.localizedString("yourTurnToBid")
        } else if player.currentBid != -1 {
            return "\(game.localizedString("bid")): \(player.currentBid)"
        } else {
            return game.localizedString("waitingToBid")
        }
    }
    
    var takeStatus: String {
        if player.currentTricks != -1 {
            return "\(game.localizedString("tricks")): \(player.currentTricks)"
        } else if isNextToTake {
            return game.localizedString("yourTurnToTake")
        } else {
            return game.localizedString("waitingToTake")
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Player Header with gradient background
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(player.name)
                            .font(.headline)
                            .foregroundColor(player.isDealer ? .jokerRed : .primary)
                        
                        if player.isDealer {
                            Text("(\(game.localizedString("dealer")))")
                                .font(.caption)
                                .foregroundColor(.jokerRed)
                        }
                    }
                    
                    Text("\(game.localizedString("score")): \(formatScore(player.score))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isNextToBid || isNextToTake {
                    Circle()
                        .fill(Color.jokerRed)
                        .frame(width: 8, height: 8)
                        .padding(.trailing, 4)
                }
            }
            
            Divider()
            
            // Status Section with animated colors
            VStack(spacing: 4) {
                Text(bidStatus)
                    .font(.caption)
                    .foregroundColor(isNextToBid ? .jokerRed : .secondary)
                
                Text(takeStatus)
                    .font(.caption)
                    .foregroundColor(isNextToTake ? .jokerRed : .secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(cardBackgroundColor)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(player.isDealer ? Color.jokerRed : Color.clear, lineWidth: 2)
        )
    }
}

struct RoundScoresView: View {
    @ObservedObject var game: Game
    @Binding var selectedRound: Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Round", selection: $selectedRound) {
                    ForEach(1...game.currentRound, id: \.self) { round in
                        Text("Round \(round)").tag(round)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if let scores = game.getRoundScores(round: selectedRound) {
                    List {
                        ForEach(0..<game.players.count, id: \.self) { index in
                            HStack {
                                Text(game.players[index].name)
                                Spacer()
                                Text("\(scores[index])")
                                    .foregroundColor(scores[index] >= 0 ? .green : .red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Round Scores")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct PlayerCard: View {
    let player: Game.Player
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(player.isDealer ? Color.gold.opacity(0.7) : Color.blue.opacity(0.7))
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.white.opacity(0.3), lineWidth: 2)
    }
    
    private var playerInfo: some View {
        VStack {
            Text(player.name)
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Score: \(player.score)")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 5)
            
            bidAndTricksView
        }
    }
    
    private var bidAndTricksView: some View {
        HStack {
            VStack {
                Text("Bid")
                    .font(.caption)
                Text("\(player.currentBid)")
                    .font(.title3)
            }
            
            Spacer()
            
            VStack {
                Text("Tricks")
                    .font(.caption)
                Text("\(player.currentTricks)")
                    .font(.title3)
            }
        }
        .padding(.top, 5)
    }
    
    var body: some View {
        playerInfo
            .padding()
            .background(cardBackground)
            .overlay(cardBorder)
    }
}

struct PlayerSetupView: View {
    @ObservedObject var game: Game
    @State private var playerNames: [String] = Array(repeating: "", count: 4)
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ForEach(0..<4) { index in
                    TextField("Player \(index + 1) Name", text: $playerNames[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Button("Start Game") {
                    for name in playerNames where !name.isEmpty {
                        game.addPlayer(name: name)
                    }
                    game.startRound()
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("Setup Players")
        }
    }
}

struct BidSheet: View {
    let player: Game.Player
    let onBid: (Int) -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedBid: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(player.name)'s Bid")
                    .font(.title)
                    .padding()
                
                Picker("Bid", selection: $selectedBid) {
                    ForEach(0...8, id: \.self) { bid in
                        Text("\(bid)").tag(bid)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Button("Confirm") {
                    onBid(selectedBid)
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct TrickSheet: View {
    @ObservedObject var game: Game
    @Environment(\.presentationMode) var presentationMode
    
    private var header: some View {
        Text("Add Trick")
            .font(.title)
            .padding()
    }
    
    private func playerButton(for player: Game.Player) -> some View {
        Button(action: {
            // Increment the current tricks by 1
            let currentTricks = player.currentTricks == -1 ? 0 : player.currentTricks
            game.setTricks(for: player, tricks: currentTricks + 1)
            presentationMode.wrappedValue.dismiss()
        }) {
            Text(player.name)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                header
                
                ForEach(game.players) { player in
                    playerButton(for: player)
                }
            }
            .navigationBarItems(trailing: cancelButton)
        }
    }
}

struct RoundInfoView: View {
    @ObservedObject var game: Game
    @Environment(\.colorScheme) var colorScheme
    
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    private var cardBackgroundColor: Color {
        isDarkMode ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    private var totalBids: Int {
        game.players.reduce(0) { $0 + ($1.currentBid == -1 ? 0 : $1.currentBid) }
    }
    
    private var cardsInRound: Int {
        game.cardsInRound()
    }
    
    private var gameStatus: String {
        if !game.isBiddingComplete {
            return game.localizedString("biddingPhase")
        }
        
        if totalBids < cardsInRound {
            return "\(game.localizedString("shet'enva")): \(cardsInRound - totalBids)"
        } else if totalBids > cardsInRound {
            // Calculate excess bids (total bids - cards in round)
            let excessBids = totalBids - cardsInRound
            
            // If excess bids exceed the cards in round, ts'aglejva is capped at cards in round
            // Otherwise, ts'aglejva is the excess bids
            let tsaglejva = min(excessBids, cardsInRound)
            return "\(game.localizedString("ts'aglejva")): \(tsaglejva)"
        } else {
            return game.localizedString("biddingComplete")
        }
    }
    
    private var roundDescription: String {
        switch game.currentRound {
        case 1...8:
            return "\(game.localizedString("round")) \(game.currentRound): \(game.currentRound) \(game.localizedString("cards"))"
        case 9...12:
            return "\(game.localizedString("round")) \(game.currentRound): \(game.localizedString("nines"))"
        case 13...20:
            return "\(game.localizedString("round")) \(game.currentRound): \(21 - game.currentRound) \(game.localizedString("cards"))"
        default:
            return "\(game.localizedString("round")) \(game.currentRound)"
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(roundDescription)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.jokerRed)
            
            HStack(spacing: 15) {
                Label(gameStatus, systemImage: game.isBiddingComplete ? "checkmark.circle.fill" : "circle.fill")
                    .foregroundColor(game.isBiddingComplete ? .jokerGreen : .jokerRed)
                
                if game.isRoundComplete {
                    Label(game.localizedString("roundComplete"), systemImage: "checkmark.circle.fill")
                        .foregroundColor(.jokerGreen)
                }
            }
            .font(.subheadline)
            
            if game.isGameComplete {
                Text(game.localizedString("gameComplete"))
                    .font(.headline)
                    .foregroundColor(.jokerGreen)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(cardBackgroundColor)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

extension View {
    func forceLandscape() -> some View {
        self.modifier(LandscapeModifier())
    }
}

struct StandardGameView: View {
    @ObservedObject var game: Game
    @Environment(\.colorScheme) var colorScheme
    @Binding var showingFinalScores: Bool
    @Binding var showingUndoView: Bool
    
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    private var gridColor: Color {
        isDarkMode ? Color.white.opacity(0.2) : Color.black.opacity(0.2)
    }
    
    private var cardBackgroundColor: Color {
        isDarkMode ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    private func cellBackgroundColor(row: Int, column: Int) -> Color {
        if let currentPlayer = currentPlayer,
           row == game.players.firstIndex(where: { $0.id == currentPlayer.id }) {
            return Color.green.opacity(0.2)
        }
        return Color.clear
    }
    
    private func formatScore(_ score: Int) -> String {
        if score == 0 {
            return "0.0"
        }
        let absScore = abs(score)
        let wholePart = absScore / 100
        let decimalPart = (absScore % 100) / 10
        let formattedScore = "\(wholePart).\(decimalPart)"
        return score < 0 ? "-\(formattedScore)" : formattedScore
    }
    
    private var currentPlayer: Game.Player? {
        if let nextBidder = game.getNextBidder() {
            return nextBidder
        } else if let nextTaker = game.getNextTaker() {
            return nextTaker
        }
        return nil
    }
    
    private var availableNumbers: [Int] {
        guard let player = currentPlayer else { return [] }
        
        if !game.isBiddingComplete && player.currentBid == -1 {
            return Array(0...game.cardsInRound())
        } else if game.isBiddingComplete && player.currentTricks == -1 {
            let otherPlayersTricks = game.players
                .filter { $0.id != player.id }
                .reduce(0) { $0 + ($1.currentTricks == -1 ? 0 : $1.currentTricks) }
            let remainingTricks = game.cardsInRound() - otherPlayersTricks
            
            if remainingTricks > 0 && game.players.filter({ $0.currentTricks == -1 }).count == 1 {
                return [remainingTricks]
            }
            
            return remainingTricks >= 0 ? Array(0...remainingTricks) : []
        }
        return []
    }
    
    private func isBidValid(_ bid: Int) -> Bool {
        guard let player = currentPlayer, player.isDealer else { return true }
        let otherPlayersBids = game.players
            .filter { $0.id != player.id }
            .reduce(0) { $0 + ($1.currentBid == -1 ? 0 : $1.currentBid) }
        return bid + otherPlayersBids != game.cardsInRound()
    }
    
    private func handleNumberSelection(_ number: Int) {
        guard let player = currentPlayer else { return }
        if !game.isBiddingComplete && player.currentBid == -1 {
            game.setBid(for: player, bid: number)
        } else if game.isBiddingComplete && player.currentTricks == -1 {
            let otherPlayersTricks = game.players
                .filter { $0.id != player.id }
                .reduce(0) { $0 + ($1.currentTricks == -1 ? 0 : $1.currentTricks) }
            let remainingTricks = game.cardsInRound() - otherPlayersTricks
            
            if remainingTricks > 0 && game.players.filter({ $0.currentTricks == -1 }).count == 1 {
                game.setTricks(for: player, tricks: remainingTricks)
            } else {
                game.setTricks(for: player, tricks: number)
            }
        }
    }
    
    private var numberKeyboard: some View {
        VStack(spacing: 0) {
            Text("\(currentPlayer?.name ?? "")'s \(game.isBiddingComplete ? game.localizedString("tricks") : game.localizedString("bid"))")
                .font(.caption)
                .padding(.vertical, 2)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 0) {
                ForEach(availableNumbers, id: \.self) { number in
                    let isValid = !game.isBiddingComplete && currentPlayer?.isDealer == true ? 
                        isBidValid(number) : true
                    
                    Button(action: { 
                        if isValid {
                            handleNumberSelection(number)
                        }
                    }) {
                        Text("\(number)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(isValid ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                            .background(isValid ? Color.blue : Color.gray.opacity(0.3))
                    }
                    .disabled(!isValid)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(6)
        .shadow(radius: 1)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top section - Game Table
                ScrollView {
                    VStack(spacing: 10) {
                        // Round Info and Table
                        VStack(spacing: 8) {
                            // Round Info
                            RoundInfoView(game: game)
                                .frame(maxWidth: .infinity)
                            
                            // Game Table
                            VStack(spacing: 0) {
                                // Header Row
                                HStack(spacing: 0) {
                                    Text("")
                                        .frame(width: 40)
                                        .padding(8)
                                        .border(gridColor)
                                    
                                    ForEach(game.players) { player in
                                        VStack {
                                            Text(player.name)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(player.isDealer ? .jokerRed : .primary)
                                            if player.isDealer {
                                                Text("D")
                                                    .font(.caption2)
                                                    .foregroundColor(.jokerRed)
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .border(gridColor)
                                    }
                                }
                                
                                // Bid Rows
                                ForEach(0..<game.currentRound, id: \.self) { round in
                                    HStack(spacing: 0) {
                                        // Round number display logic
                                        let roundNumber = round + 1
                                        let displayNumber: String = {
                                            if roundNumber <= 8 {
                                                return "\(roundNumber)"  // Rounds 1-8: show actual round number
                                            } else if (roundNumber >= 9 && roundNumber <= 12) || (roundNumber >= 21 && roundNumber <= 24) {
                                                return "9"  // Both sets of nine rounds: show "9"
                                            } else if roundNumber >= 13 && roundNumber <= 20 {
                                                return "\(21 - roundNumber)"  // Rounds 13-20: show decreasing cards
                                            } else {
                                                return "\(roundNumber)"  // Fallback for any other rounds
                                            }
                                        }()
                                        
                                        Text(displayNumber)
                                            .font(.system(size: 12))
                                            .frame(width: 30)
                                            .padding(4)
                                            .border(gridColor)
                                        
                                        ForEach(game.players) { player in
                                            let roundData = game.getRoundBidsAndTakes(round: round + 1)
                                            let playerData = roundData.first(where: { $0.player.id == player.id })
                                            
                                            VStack(spacing: 2) {
                                                if round + 1 == game.currentRound {
                                                    // For current round, show real-time bid/take
                                                    Text(player.currentBid == -1 ? "-" : "\(player.currentBid)")
                                                        .font(.system(size: 12))
                                                    Text(player.currentTricks == -1 ? "-" : "\(player.currentTricks)")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.secondary)
                                                } else {
                                                    // For previous rounds
                                                    Text("\(playerData?.bid ?? -1)")
                                                        .font(.system(size: 12))
                                                    Text("\(playerData?.tricks ?? -1)")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(4)
                                            .background(cellBackgroundColor(row: game.players.firstIndex(where: { $0.id == player.id }) ?? 0, column: round))
                                            .border(gridColor)
                                        }
                                    }
                                }
                                
                                // Score Row
                                HStack(spacing: 0) {
                                    Text("Score")
                                        .font(.system(size: 14, weight: .bold))
                                        .frame(width: 40)
                                        .padding(8)
                                        .border(gridColor)
                                    
                                    ForEach(game.players) { player in
                                        Text(formatScore(player.score))
                                            .font(.system(size: 14, weight: .bold))
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .border(gridColor)
                                    }
                                }
                            }
                            .background(cardBackgroundColor)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding(.vertical, 8)
                }
                
                Spacer()
                
                // Bottom section - Controls and Keyboard
                VStack(spacing: 8) {
                    // Action Buttons in a horizontal row
                    HStack(spacing: 8) {
                        if game.isRoundComplete {
                            Button(action: {
                                game.startRound()
                            }) {
                                Text(game.localizedString("nextRound"))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        
                        Button(action: {
                            showingUndoView = true
                        }) {
                            Text(game.localizedString("undo"))
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color.orange)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showingFinalScores = true
                        }) {
                            Text(game.isGameComplete ? game.localizedString("showFinalScores") : game.localizedString("returnHome"))
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(game.isGameComplete ? Color.green : Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    // Keyboard at the bottom
                    if !availableNumbers.isEmpty {
                        numberKeyboard
                            .frame(maxHeight: geometry.size.height * 0.25)
                    }
                }
                .padding(.bottom, 8)
                .background(cardBackgroundColor)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
} 
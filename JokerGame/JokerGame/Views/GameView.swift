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
}

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var showMainContent = false
    @Binding var showSplash: Bool
    
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSplash = false
                }
            }
        }
    }
}

struct SettingsView: View {
    @Binding var selectedTheme: AppTheme
    @Binding var selectedGameMode: Game.GameMode
    @Binding var selectedKhisthi: Game.KhisthiMode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
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
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Theme Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Appearance")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Theme")
                                .font(.headline)
                                .foregroundColor(textColor)
                            
                            Picker("Theme", selection: $selectedTheme) {
                                ForEach(AppTheme.allCases, id: \.self) { theme in
                                    Text(theme.rawValue)
                                        .tag(theme)
                                        .foregroundColor(textColor)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .background(cardBackgroundColor)
                            .cornerRadius(8)
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
                        Text("Game Mode")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Game Mode", selection: $selectedGameMode) {
                                ForEach(Game.GameMode.allCases, id: \.self) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Text(gameModeDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
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
                        Text("Khisthi Mode")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Khisthi Mode", selection: $selectedKhisthi) {
                                ForEach(Game.KhisthiMode.allCases, id: \.self) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Text(khisthiModeDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
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
                        Text("Game Rules")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.jokerRed)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(gameRules)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
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
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private var gameModeDescription: String {
        switch selectedGameMode {
        case .standard:
            return "Standard mode: 8-9-8-9 card distribution"
        case .nines:
            return "All Nines mode: 4 rounds with 9 cards each"
        }
    }
    
    private var khisthiModeDescription: String {
        switch selectedKhisthi {
        case .speci:
            return "Speci mode: Special scoring for khisthi"
        case .fixed200:
            return "Fixed -200: Standard khisthi penalty"
        case .fixed500:
            return "Fixed -500: Higher khisthi penalty"
        }
    }
    
    private var gameRules: String {
        """
        • Each round, players bid on how many tricks they'll take
        • The dealer cannot bid the total number of cards
        • Players must take exactly their bid to score points
        • Taking more or fewer tricks than bid results in penalties
        • The game ends after all rounds are complete
        • Highest score wins!
        """
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
    @State private var selectedTheme: AppTheme = .system
    @Environment(\.colorScheme) var colorScheme
    @State private var showingSettings = false
    
    private var currentTheme: ColorScheme {
        switch selectedTheme {
        case .light: return .light
        case .dark: return .dark
        case .system: return colorScheme
        }
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
            Text(inputTitle)
                .font(.headline)
                .padding(.vertical, 8)
            
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
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(isValid ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(isValid ? Color.blue : Color.gray.opacity(0.3))
                    }
                    .disabled(!isValid)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var finalScoresView: some View {
        VStack(spacing: 15) {
            Text(game.isGameComplete ? "Final Scores" : "Current Scores")
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
                Text("Game Incomplete - \(game.currentRound) rounds played")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            
            Button(action: {
                showingFinalScores = false
                game.resetGame()
            }) {
                Text("Return Home")
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
            Text("Round \(selectedRound) Scores")
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
                Text("Done")
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
                SplashScreen(showSplash: $showSplash)
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
                                    TextField("Player \(index + 1) Name", text: $playerNames[index])
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
                                    Text("Start Game")
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
                                        Text("Settings")
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
                                selectedKhisthi: $selectedKhisthi
                            )
                        }
                    } else {
                        // Main Game View
                        ZStack {
                            ScrollView {
                                VStack(spacing: 15) {
                                    // Round Info Card with gradient
                                    RoundInfoView(game: game)
                                        .padding(.horizontal)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.jokerRed.opacity(0.1), .jokerGreen.opacity(0.1)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                    
                                    // Players Grid with animated cards
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
                                                Text("Next Round")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.blue)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        
                                        Button(action: {
                                            showingFinalScores = true
                                        }) {
                                            Text(game.isGameComplete ? "Show Final Scores" : "Return Home")
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
                                }
                                .padding(.vertical)
                                .padding(.bottom, availableNumbers.isEmpty ? 0 : 200)
                            }
                            .preferredColorScheme(currentTheme)
                            .background(backgroundColor)
                            
                            if !availableNumbers.isEmpty {
                                VStack {
                                    Spacer()
                                    numberKeyboard
                                        .padding()
                                }
                            }
                        }
                        .navigationTitle("Joker Game")
                        .sheet(isPresented: $showingFinalScores) {
                            finalScoresView
                        }
                    }
                }
            }
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
            return "Bid: \(player.currentBid == -1 ? "Not set" : String(player.currentBid))"
        } else if isNextToBid {
            return "Your turn to bid"
        } else if player.currentBid != -1 {
            return "Bid: \(player.currentBid)"
        } else {
            return "Waiting to bid"
        }
    }
    
    var takeStatus: String {
        if player.currentTricks != -1 {
            return "Took: \(player.currentTricks)"
        } else if isNextToTake {
            return "Your turn to take"
        } else {
            return "Waiting to take"
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
                            Text("(Dealer)")
                                .font(.caption)
                                .foregroundColor(.jokerRed)
                        }
                    }
                    
                    Text("Score: \(formatScore(player.score))")
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
    
    private var roundDescription: String {
        switch game.currentRound {
        case 1...8:
            return "Round \(game.currentRound): \(game.currentRound) cards"
        case 9...12:
            return "Round \(game.currentRound): Nines (9 cards)"
        case 13...20:
            return "Round \(game.currentRound): \(21 - game.currentRound) cards"
        default:
            return "Round \(game.currentRound)"
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
                if game.isBiddingComplete {
                    Label("Bidding Complete", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.jokerGreen)
                } else {
                    Label("Bidding Phase", systemImage: "circle.fill")
                        .foregroundColor(.jokerRed)
                }
                
                if game.isRoundComplete {
                    Label("Round Complete", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.jokerGreen)
                }
            }
            .font(.subheadline)
            
            if game.isGameComplete {
                Text("Game Complete!")
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
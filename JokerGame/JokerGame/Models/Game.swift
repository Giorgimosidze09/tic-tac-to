import Foundation
import AVFoundation

class Game: ObservableObject {
    enum Language: String, CaseIterable {
        case english = "English"
        case georgian = "ქართული"
    }
    
    @Published var selectedLanguage: Language = .english
    
    // Localized strings
    var localizedStrings: [String: String] {
        switch selectedLanguage {
        case .english:
            return [
                "player": "Player",
                "dealer": "Dealer",
                "bid": "Bid",
                "tricks": "Tricks",
                "score": "Score",
                "nextRound": "Next Round",
                "yourTurnToBid": "Your turn to bid",
                "waitingToBid": "Waiting to bid",
                "yourTurnToTake": "Your turn to take",
                "waitingToTake": "Waiting to take",
                "biddingComplete": "Bidding Complete",
                "biddingPhase": "Bidding Phase",
                "roundComplete": "Round Complete",
                "gameComplete": "Game Complete",
                "round": "Round",
                "cards": "cards",
                "nines": "Nines",
                "startGame": "Start Game",
                "settings": "Settings",
                "appearance": "Appearance",
                "theme": "Theme",
                "language": "Language",
                "gameMode": "Game Mode",
                "khisthiMode": "Khisthi Mode",
                "gameRules": "Game Rules",
                "done": "Done",
                "cancel": "Cancel",
                "returnHome": "Return Home",
                "showFinalScores": "Show Final Scores",
                "currentScores": "Current Scores",
                "finalScores": "Final Scores",
                "gameIncomplete": "Game Incomplete",
                "roundsPlayed": "rounds played",
                "light": "Light",
                "dark": "Dark",
                "system": "System",
                "standard": "Standard",
                "standardModeDescription": "Standard mode: 8-9-8-9 card distribution",
                "ninesModeDescription": "All Nines mode: 4 rounds with 9 cards each",
                "speci": "Speci",
                "fixed200": "Fixed -200",
                "fixed500": "Fixed -500",
                "speciModeDescription": "Speci mode: Special scoring for khisthi",
                "fixed200ModeDescription": "Fixed -200: Standard khisthi penalty",
                "fixed500ModeDescription": "Fixed -500: Higher khisthi penalty",
                "shet'enva": "Underbid",
                "ts'aglejva": "Overbid",
                "gameRulesDescription": """
                • Each round, players bid on how many tricks they'll take
                • The dealer cannot bid the total number of cards
                • Players must take exactly their bid to score points
                • Taking more or fewer tricks than bid results in penalties
                • The game ends after all rounds are complete
                • Highest score wins!
                """,
                "undo": "Undo Round",
                "undoRound": "Undo Round",
                "applyChanges": "Apply Changes"
            ]
        case .georgian:
            return [
                "player": "მოთამაშე",
                "dealer": "დამრიგებელი",
                "bid": "ნათქვამი",
                "tricks": "წაღებები",
                "score": "ქულა",
                "nextRound": "შემდეგი რაუნდი",
                "yourTurnToBid": "თქვიიიიიი",
                "waitingToBid": "აცადეე თქვაას",
                "yourTurnToTake": "რამდენი წაიღეე",
                "waitingToTake": "აცადე თქვას რა წაიღო",
                "biddingComplete": "შეთავაზება დასრულებულია",
                "biddingPhase": "შეთავაზების ფაზა",
                "roundComplete": "რაუნდი დასრულებულია",
                "gameComplete": "თამაში დასრულებულია",
                "round": "რაუნდი",
                "cards": "ბარათი",
                "nines": "ცხრები",
                "startGame": "თამაშის დაწყება",
                "settings": "პარამეტრები",
                "appearance": "გარეგნობა",
                "theme": "თემა",
                "language": "ენა",
                "gameMode": "თამაშის რეჟიმი",
                "khisthiMode": "ხიშტის რეჟიმი",
                "gameRules": "თამაშის წესები",
                "done": "მზადაა",
                "cancel": "გაუქმება",
                "returnHome": "მთავარი გვერდი",
                "showFinalScores": "ფინალური ქულების ჩვენება",
                "currentScores": "მიმდინარე ქულები",
                "finalScores": "ფინალური ქულები",
                "gameIncomplete": "თამაში დაუსრულებელია",
                "roundsPlayed": "ჩატარებული რაუნდი",
                "light": "ღია",
                "dark": "მუქი",
                "system": "სისტემა",
                "standard": "სტანდარტული",
                "standardModeDescription": "სტანდარტული რეჟიმი: 8-9-8-9 ბარათის განაწილება",
                "ninesModeDescription": "ცხრების რეჟიმი: 4 რაუნდი თითო 9 ბარათით",
                "speci": "სპეცი",
                "fixed200": " -200",
                "fixed500": " -500",
                "speciModeDescription": "სპეცი რეჟიმი: სპეციალური ქულების დათვლა ქიშტისთვის",
                "fixed200ModeDescription": "ფიქსირებული -200: სტანდარტული ქიშტის ჯარიმა",
                "fixed500ModeDescription": "ფიქსირებული -500: მაღალი ქიშტის ჯარიმა",
                "shet'enva": "შეტენვა",
                "ts'aglejva": "წაგლეჯვა",
                "gameRulesDescription": """
                • ყოველ რაუნდში მოთამაშეები აცხადებენ რამდენ შემტაცებელს აიღებენ
                • დილერს არ შეუძლია ბარათების რაოდენობის ტოლი შეთავაზების გაკეთება
                • მოთამაშეებმა ზუსტად უნდა აიღონ შეთავაზებული რაოდენობის შემტაცებელი
                • მეტის ან ნაკლების აღება იწვევს ჯარიმას
                • თამაში მთავრდება ყველა რაუნდის დასრულების შემდეგ
                • მაღალი ქულა იმარჯვებს!
                """,
                "undo": "რაუნდის გაუქმება",
                "undoRound": "რაუნდის გაუქმება",
                "applyChanges": "ცვლილებების გამოყენება"
            ]
        }
    }
    
    // Helper function to get localized string
    func localizedString(_ key: String) -> String {
        return localizedStrings[key] ?? key
    }
    
    enum GameMode: String, CaseIterable {
        case standard = "standard"
        case nines = "nines"
    }
    
    enum KhisthiMode: String, CaseIterable {
        case speci = "Speci"
        case fixed200 = " -200"
        case fixed500 = " -500"
    }
    
    @Published var players: [Player] = []
    @Published var currentRound: Int = 1
    @Published var isGameSetup = false
    @Published var isRoundComplete = false
    @Published var isGameComplete = false
    @Published var isBiddingComplete = false
    var kishtiPenalty = -200
    
    @Published var gameMode: GameMode = .standard
    @Published var khisthiMode: KhisthiMode = .speci
    
    private var audioPlayer: AVAudioPlayer?
    
    // Add these properties after other @Published properties
    @Published var isUndoMode: Bool = false
    @Published var selectedUndoRound: Int = 1
    
    // Add this property to track bidding order
    private var biddingOrder: [UUID] = []
    
    // Add this struct before the Game class
    struct RoundData {
        var bids: [UUID: Int] = [:]
        var tricks: [UUID: Int] = [:]
        var scores: [Int] = []
    }

    // Update the roundScores property
    private var roundScores: [RoundData] = []
    
    class Player: Identifiable {
        let id = UUID()
        let name: String
        var score = 0
        var currentBid = -1
        var currentTricks = -1
        var isDealer = false
        var roundScores: [Int] = []
        
        init(name: String) {
            self.name = name
        }
    }
    
    func addPlayer(name: String) {
        let player = Player(name: name)
        players.append(player)
    }
    
    func startGame() {
        guard players.count == 4 else { return }
        isGameSetup = true
        currentRound = 1
        isRoundComplete = false
        isGameComplete = false
        isBiddingComplete = false
        roundScores = []
        biddingOrder = []  // Reset bidding order
        
        // Set last player as dealer
        for i in 0..<players.count {
            players[i].isDealer = (i == players.count - 1)
            players[i].score = 0
            players[i].currentTricks = -1
            players[i].currentBid = -1
            players[i].roundScores = []
        }
    }
    
    func startRound() {
        // Rotate dealer
        if let currentDealerIndex = players.firstIndex(where: { $0.isDealer }) {
            players[currentDealerIndex].isDealer = false
            let nextDealerIndex = (currentDealerIndex + 1) % players.count
            players[nextDealerIndex].isDealer = true
        }
        
        for i in 0..<players.count {
            players[i].currentTricks = -1
            players[i].currentBid = -1
        }
        isRoundComplete = false
        isBiddingComplete = false
        biddingOrder = []  // Reset bidding order
    }
    
    func setBid(for player: Player, bid: Int) {
        guard let index = players.firstIndex(where: { $0.id == player.id }) else { return }
        
        // Check if bid is valid
        let cardsInRound = cardsInRound()
        guard bid <= cardsInRound else { return }
        
        // If this is the dealer and other players' bids sum to cards in round, dealer cannot bid 0
        if player.isDealer && bid == 0 {
            let otherBids = players.filter { $0.id != player.id }.map { $0.currentBid }
            let sumOfOtherBids = otherBids.reduce(0) { $0 + ($1 == -1 ? 0 : $1) }
            if sumOfOtherBids == cardsInRound {
                return // Invalid bid for dealer
            }
        }
        
        // Set the bid and record the bidding order
        players[index].currentBid = bid
        if !biddingOrder.contains(player.id) {
            biddingOrder.append(player.id)
        }
        
        // Check if all players have bid
        let allBidsSet = players.allSatisfy { $0.currentBid != -1 }
        if allBidsSet {
            isBiddingComplete = true
        }
        
        // Force UI update
        objectWillChange.send()
    }
    
    func setTricks(for player: Player, tricks: Int) {
        guard let index = players.firstIndex(where: { $0.id == player.id }) else { return }
        
        // Calculate total tricks taken so far (excluding current player)
        let otherPlayersTricks = players.filter { $0.id != player.id }.reduce(0) { $0 + ($1.currentTricks == -1 ? 0 : $1.currentTricks) }
        let cardsInRound = cardsInRound()
        
        // Set the player's tricks
        players[index].currentTricks = tricks
        
        // Calculate new total tricks
        let totalTricks = players.reduce(0) { $0 + ($1.currentTricks == -1 ? 0 : $1.currentTricks) }
        
        // If total equals cards dealt, auto-set remaining players to 0
        if totalTricks == cardsInRound {
            for i in 0..<players.count {
                if players[i].currentTricks == -1 {
                    players[i].currentTricks = 0
                }
            }
            checkRoundCompletion()
            objectWillChange.send()
            return
        }
        
        // If this is the last player to take and sum doesn't equal cards dealt
        let remainingPlayers = players.filter { $0.currentTricks == -1 }
        if remainingPlayers.count == 1 && remainingPlayers[0].id == player.id {
            // Calculate remaining tricks needed
            let remainingTricks = cardsInRound - otherPlayersTricks
            if remainingTricks >= 0 {
                // Set the last player's take to the remaining amount
                players[index].currentTricks = remainingTricks
                checkRoundCompletion()
                objectWillChange.send()
                return
            }
        }
        
        // Check if all players have taken
        let allTricksSet = players.allSatisfy { $0.currentTricks != -1 }
        if allTricksSet {
            checkRoundCompletion()
        }
        
        // Force UI update
        objectWillChange.send()
    }
    
    func calculateScore(for player: Player) -> Int {
        let bid = player.currentBid
        let tricks = player.currentTricks
        let cardsDealt = cardsInRound()
        
        if bid == tricks {
            if bid == 0 {
                return 50  // Special case for bid 0, take 0
            } else {
                // If bid matches both tricks and cards dealt, give 100 points per card
                if bid == cardsDealt {
                    return bid * 100  // 100 for bid 1, 200 for bid 2, 300 for bid 3, etc.
                } else {
                    return 50 + (bid * 50)  // 100 for bid 1, 150 for bid 2, 200 for bid 3, etc.
                }
            }
        } else {
            let isKhisthi = bid > 0 && tricks == 0
            
            if isKhisthi {
                switch khisthiMode {
                case .speci:
                    return -100 * cardsInRound()
                case .fixed200:
                    return -200
                case .fixed500:
                    return -500
                }
            } else {
                let difference = abs(bid - tricks)
                return difference * 10  // 10 points per difference
            }
        }
    }
    
    private func checkRoundCompletion() {
        // Check if all players have made their takes
        let allTricksSet = players.allSatisfy { $0.currentTricks != -1 }
        
        if allTricksSet {
            // Create new round data
            var roundData = RoundData()
            
            // Calculate scores for this round
            for i in 0..<players.count {
                let score = calculateScore(for: players[i])
                players[i].score += score
                players[i].roundScores.append(score)
                roundData.scores.append(score)
                
                // Store bids and tricks
                roundData.bids[players[i].id] = players[i].currentBid
                roundData.tricks[players[i].id] = players[i].currentTricks
            }
            
            roundScores.append(roundData)
            
            // Check if this was the last round
            if currentRound >= 24 {
                isGameComplete = true
            } else {
                currentRound += 1
                isRoundComplete = true
                startRound()  // Start next round with rotated dealer
            }
        }
    }
    
    func resetGame() {
        players.removeAll()
        currentRound = 1
        isGameSetup = false
        isRoundComplete = false
        isGameComplete = false
        isBiddingComplete = false
        roundScores = []
        biddingOrder = []  // Reset bidding order
    }
    
    func cardsInRound() -> Int {
        switch gameMode {
        case .standard:
            switch currentRound {
            case 1...8: return currentRound  // 1 to 8 cards
            case 9...12: return 9  // Four rounds of nines
            case 13...20: return 21 - currentRound  // 8 to 1 cards
            case 21...24: return 9  // Four more rounds of nines
            default: return 0
            }
        case .nines:
            return 9  // All rounds are nines
        }
    }
    
    // Get scores for a specific round
    func getRoundScores(round: Int) -> [Int]? {
        guard round > 0 && round <= roundScores.count else { return nil }
        return roundScores[round - 1].scores
    }
    
    // Get the next player who should bid (player after dealer)
    func getNextBidder() -> Player? {
        // If bidding is complete, return nil
        guard !isBiddingComplete else { return nil }
        
        // Find the dealer
        guard let dealerIndex = players.firstIndex(where: { $0.isDealer }) else { return nil }
        
        // Start with player after dealer
        let startIndex = (dealerIndex + 1) % players.count
        
        // Find the first player who hasn't bid yet
        for i in 0..<players.count {
            let index = (startIndex + i) % players.count
            if players[index].currentBid == -1 {
                return players[index]
            }
        }
        
        // If we get here, all players have bid
        isBiddingComplete = true
        return nil
    }
    
    // Check if a bid is valid for a player
    func isValidBid(for player: Player, bid: Int) -> Bool {
        let cardsInRound = cardsInRound()
        
        // Bid cannot exceed cards in round
        guard bid <= cardsInRound else { return false }
        
        // If this is the dealer
        if player.isDealer {
            // Calculate sum of other players' bids
            let otherBids = players.filter { $0.id != player.id }.map { $0.currentBid }
            let sumOfOtherBids = otherBids.reduce(0) { $0 + ($1 == -1 ? 0 : $1) }
            
            // Dealer cannot bid a number that would make total bids equal cards in round
            if sumOfOtherBids + bid == cardsInRound {
                return false
            }
            
            // Dealer cannot bid 0 if other players' bids sum to cards in round
            if bid == 0 && sumOfOtherBids == cardsInRound {
                return false
            }
        }
        
        return true
    }
    
    // Get the next player who should take tricks
    func getNextTaker() -> Player? {
        // If bidding isn't complete, return nil
        guard isBiddingComplete else { return nil }
        
        // Find the dealer
        guard let dealer = players.first(where: { $0.isDealer }) else { return nil }
        
        // If dealer hasn't taken yet and others have, dealer goes last
        if dealer.currentTricks == -1 && players.filter({ $0.id != dealer.id }).allSatisfy({ $0.currentTricks != -1 }) {
            return dealer
        }
        
        // Otherwise, follow bidding order
        for playerId in biddingOrder {
            if let player = players.first(where: { $0.id == playerId && $0.currentTricks == -1 }) {
                return player
            }
        }
        
        return nil
    }
    
    // Localized strings for game mode descriptions
    func getGameModeDescription(_ mode: GameMode) -> String {
        switch mode {
        case .standard:
            return localizedString("standardModeDescription")
        case .nines:
            return localizedString("ninesModeDescription")
        }
    }
    
    func playBackgroundMusic() {
        print("Attempting to play background music...")
        
        // Try to find the file in the main bundle
        if let url = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            print("✅ Found music file in main bundle at: \(url.path)")
            playMusicFromURL(url)
        } else {
            print("❌ Could not find background_music.mp3 in main bundle")
            print("Current bundle path: \(Bundle.main.bundlePath)")
            print("Available resources: \(Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil))")
        }
    }
    
    private func playMusicFromURL(_ url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            print("✅ Successfully created audio player")
            
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.volume = 0.5 // Set volume to 50%
            
            if audioPlayer?.play() == true {
                print("✅ Successfully started playing music")
            } else {
                print("❌ Failed to start playing music")
            }
        } catch {
            print("❌ Error playing background music: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    // Add these methods before the end of the class
    func enterUndoMode() {
        isUndoMode = true
        selectedUndoRound = currentRound - 1
    }
    
    func exitUndoMode() {
        isUndoMode = false
        selectedUndoRound = 1
    }
    
    func getRoundBidsAndTakes(round: Int) -> [(player: Player, bid: Int, tricks: Int)] {
        guard round > 0 && round <= roundScores.count else { return [] }
        let roundData = roundScores[round - 1]
        return players.map { player in
            (player: player, 
             bid: roundData.bids[player.id] ?? -1,
             tricks: roundData.tricks[player.id] ?? -1)
        }
    }
    
    func updateRoundBidsAndTakes(round: Int, updates: [(playerId: UUID, bid: Int?, tricks: Int?)]) {
        guard round > 0 && round <= roundScores.count else { return }
        var roundData = roundScores[round - 1]
        
        for update in updates {
            if let bid = update.bid {
                roundData.bids[update.playerId] = bid
            }
            if let tricks = update.tricks {
                roundData.tricks[update.playerId] = tricks
            }
        }
        
        // Recalculate scores for this round
        roundData.scores = []
        for player in players {
            let bid = roundData.bids[player.id] ?? -1
            let tricks = roundData.tricks[player.id] ?? -1
            let score = calculateScore(bid: bid, tricks: tricks)
            roundData.scores.append(score)
        }
        
        roundScores[round - 1] = roundData
        recalculateScores()
    }
    
    func applyUndoChanges() {
        guard isUndoMode else { return }
        
        // Reset the game state to the selected round
        currentRound = selectedUndoRound
        isBiddingComplete = false
        
        // Reset all players' current bids and tricks
        for player in players {
            player.currentBid = -1
            player.currentTricks = -1
        }
        
        // Exit undo mode
        exitUndoMode()
    }
    
    // Add a helper method for calculating score from bid and tricks
    private func calculateScore(bid: Int, tricks: Int) -> Int {
        let cardsDealt = cardsInRound()
        
        if bid == tricks {
            if bid == 0 {
                return 50  // Special case for bid 0, take 0
            } else {
                // If bid matches both tricks and cards dealt, give 100 points per card
                if bid == cardsDealt {
                    return bid * 100  // 100 for bid 1, 200 for bid 2, 300 for bid 3, etc.
                } else {
                    return 50 + (bid * 50)  // 100 for bid 1, 150 for bid 2, 200 for bid 3, etc.
                }
            }
        } else {
            let isKhisthi = bid > 0 && tricks == 0
            
            if isKhisthi {
                switch khisthiMode {
                case .speci:
                    return -100 * cardsInRound()
                case .fixed200:
                    return -200
                case .fixed500:
                    return -500
                }
            } else {
                let difference = abs(bid - tricks)
                return difference * 10  // 10 points per difference
            }
        }
    }
    
    // Add the recalculateScores method
    private func recalculateScores() {
        // Reset all player scores
        for player in players {
            player.score = 0
            player.roundScores = []
        }
        
        // Recalculate scores for each round
        for roundData in roundScores {
            for i in 0..<players.count {
                let player = players[i]
                let score = roundData.scores[i]
                player.score += score
                player.roundScores.append(score)
            }
        }
    }
} 
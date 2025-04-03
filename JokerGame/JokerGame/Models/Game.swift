import Foundation

class Game: ObservableObject {
    @Published var players: [Player] = []
    @Published var currentRound: Int = 1
    @Published var isGameSetup = false
    @Published var isRoundComplete = false
    @Published var isGameComplete = false
    @Published var isBiddingComplete = false
    var kishtiPenalty = -200
    private var roundScores: [[Int]] = []
    private var biddingOrder: [UUID] = []  // Track order of bidders
    
    var gameMode: GameView.GameMode = .standard
    var khisthiMode: GameView.KhisthiMode = .speci
    
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
            // Calculate scores for this round
            var roundScore = [Int]()
            for i in 0..<players.count {
                let score = calculateScore(for: players[i])
                players[i].score += score
                players[i].roundScores.append(score)
                roundScore.append(score)
            }
            roundScores.append(roundScore)
            
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
        return roundScores[round - 1]
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
} 
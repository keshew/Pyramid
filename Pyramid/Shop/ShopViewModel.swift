import SwiftUI

class ShopViewModel: ObservableObject {
    let contact = ShopModel()
    @Published var platforms: [ShopItems] = []
    @Published var balls: [ShopItems] = []
    @Published var coins: Int = 0
    
    init() {
        loadData()
    }
    
    func loadData() {
        coins = ShopManager.shared.getCoins()
        platforms = ShopManager.shared.getPlatforms()
        balls = ShopManager.shared.getBalls()
    }
    
    func purchaseOrSelect(type: StoreSelected, itemID: String) {
        let success = ShopManager.shared.purchaseItem(type: type, itemID: itemID)
        if success {
            updateLocalData()
        }
        // Можно добавить else для обработки отказа (например, недостаточно монет)
    }
    
    private func updateLocalData() {
        coins = ShopManager.shared.getCoins()
        platforms = ShopManager.shared.getPlatforms()
        balls = ShopManager.shared.getBalls()
    }
    
    func coinsSpendable(_ cost: Int) -> Bool {
        return coins >= cost
    }
}

import SwiftUI

@main
struct PyramidApp: App {
    var body: some Scene {
        WindowGroup {
            Loading()
                .onAppear {
                    let defaults = UserDefaults.standard
                    let hasInitializedKey = "hasInitializedShopData"
                    if !defaults.bool(forKey: hasInitializedKey) {
                        ShopManager.shared.setCoins(500)
                        ShopManager.shared.setLevel(2)
                        defaults.set(true, forKey: hasInitializedKey)
                    }
                }
        }
    }
}

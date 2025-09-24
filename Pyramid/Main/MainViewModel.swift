import SwiftUI

class MainViewModel: ObservableObject {
    let contact = MainModel()
    private let isAudioKey = "isAudio"
    private let defaults = UserDefaults.standard
    @Published var level = ShopManager.shared.getLevel()
    @Published var isAudio: Bool {
        didSet {
            defaults.set(isAudio, forKey: isAudioKey)
        }
    }
    
    init() {
        isAudio = defaults.bool(forKey: isAudioKey)
        
        NotificationCenter.default.addObserver(forName: Notification.Name("UserResourcesUpdated"), object: nil, queue: .main) { _ in
            self.level = ShopManager.shared.getLevel()
        }
        
        self.level = ShopManager.shared.getLevel()
    }
}

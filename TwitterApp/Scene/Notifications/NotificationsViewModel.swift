//
//  NotificationsViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 07.04.25.
//

class NotificationsViewModel {
    var manager = NotificationsManager()
    
    var notificationsResponse: NotificationsModel?
    var notificationsAllData: [NotificationItem] = []
    
    enum ViewState {
        case loading
        case loaded
        case notificationsSuccess
        case errorHandling(String)
        case idle
    }
    
    var stateUpdated: ((ViewState) -> Void)?
    
    var state: ViewState = .idle {
        didSet {
            stateUpdated?(state)
        }
    }
    
    func notifications() async {
        do {
            state = .loading
            
            let response = try await manager.notifications(page: (notificationsResponse?.meta?.page ?? 0) + 1)
            Task { @MainActor in
                notificationsResponse = response
                notificationsAllData.append(contentsOf: response.data?.notifications ?? [])
                state = .notificationsSuccess
                
                state = .loaded
            }
        } catch {
            Task { @MainActor in
                state = .errorHandling(error.localizedDescription)
            }
        }
    }
    
    func reset() {
        notificationsAllData = []
        notificationsResponse = nil
    }
    
    func pagination(index: Int) async {
        if notificationsAllData.count - 2 == index && (notificationsResponse?.meta?.page ?? 0 < (notificationsResponse?.meta?.totalPage ?? 0)) {
            await notifications()
        }
    }
}

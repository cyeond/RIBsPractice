//
//  AppDetailsMock.swift
//  
//
//  Created by YD on 6/14/24.
//

import Foundation
import AppDetails
import RIBs
import RIBsTestSupport
import RxSwift
import RxRelay
import UIKit
@testable import AppDetailsImp

final class AppDetailsPresentableMock: AppDetailsPresentable {
    var listener: AppDetailsPresentableListener?
}

final class AppDetailsListenerMock: AppDetailsListener {
    var appDetailsDidTapCloseCallCount = 0
    func appDetailsDidTapClose() {
        appDetailsDidTapCloseCallCount += 1
    }
}

final class AppDetailsRoutingMock: ViewableRoutingMock, AppDetailsRouting {
    var attachTopInfoDashboardCallCount = 0
    func attachTopInfoDashboard() {
        attachTopInfoDashboardCallCount += 1
    }
    
    var attachRatingInfoDashboardCallCount = 0
    func attachRatingInfoDashboard() {
        attachRatingInfoDashboardCallCount += 1
    }
    
    var attachReleaseNoteDashboardCallCount = 0
    func attachReleaseNoteDashboard() {
        attachReleaseNoteDashboardCallCount += 1
    }
    
    var attachScreenshotsDashboardCallCount = 0
    func attachScreenshotsDashboard() {
        attachScreenshotsDashboardCallCount += 1
    }
}

final class AppDetailsInteractableMock: AppDetailsInteractable {
    var router: AppDetailsRouting?
    var listener: AppDetailsListener?
    var isActive: Bool { isActiveRelay.value }
    var isActiveStream: Observable<Bool> { isActiveRelay.asObservable() }
    private let isActiveRelay = BehaviorRelay<Bool>(value: false)
    
    func activate() {
    }
    
    func deactivate() {
    }
}

final class AppDetailsViewControllableMock: AppDetailsViewControllable {
    var addDashboardCallCount = 0
    var addDashboardView: ViewControllable?
    func addDashboard(_ view: ViewControllable) {
        addDashboardView = view
        addDashboardCallCount += 1
    }
    
    var uiviewController: UIViewController = UIViewController()
}
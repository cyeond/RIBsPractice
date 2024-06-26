//
//  AppDetailsInteractor.swift
//  RIBsPractice
//
//  Created by YD on 5/17/24.
//

import RIBs
import RxSwift
import AppDetails

protocol AppDetailsRouting: ViewableRouting {
    func attachTopInfoDashboard()
    func attachRatingInfoDashboard()
    func attachReleaseNoteDashboard()
    func attachScreenshotsDashboard()
}

protocol AppDetailsPresentable: Presentable {
    var listener: AppDetailsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

final class AppDetailsInteractor: PresentableInteractor<AppDetailsPresentable>, AppDetailsInteractable, AppDetailsPresentableListener {
    weak var router: AppDetailsRouting?
    weak var listener: AppDetailsListener?
    
    private let disposeBag = DisposeBag()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppDetailsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTopInfoDashboard()
        router?.attachRatingInfoDashboard()
        router?.attachReleaseNoteDashboard()
        router?.attachScreenshotsDashboard()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBack() {
        listener?.appDetailsDidTapClose()
    }
}

//
//  ReleaseNoteDashboardRouterTests.swift
//  AppStoreClone
//
//  Created by YD on 6/17/24.
//

@testable import AppDetailsImp
import XCTest

final class ReleaseNoteDashboardRouterTests: XCTestCase {

    private var sut: ReleaseNoteDashboardRouter!

    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()

        self.sut = ReleaseNoteDashboardRouter(
            interactor: ReleaseNoteDashboardInteractableMock(),
            viewController: ReleaseNoteDashboardViewControllableMock()
        )
    }

    // MARK: - Tests
    func testDidLoad() {
        sut.didLoad()
    }
}
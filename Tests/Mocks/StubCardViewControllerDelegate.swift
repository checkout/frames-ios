//
//  StubCardViewControllerDelegate.swift
//  FramesIosTests
//
//  Created by Daven.Gomes on 12/01/2021.
//  Copyright © 2021 Checkout. All rights reserved.
//

import Frames
import Checkout

final class StubCardViewControllerDelegate: CardViewControllerDelegate {

    private(set) var onSubmitCalledWith: CardViewController?

    func onSubmit(controller: CardViewController) {
        onSubmitCalledWith = controller
    }

    private(set) var onTapDoneCalledWith: (controller: CardViewController,
                                           result: Result<TokenDetails, TokenisationError.TokenRequest>)?

    func onTapDone(controller: CardViewController,
                   result: Result<TokenDetails, TokenisationError.TokenRequest>) {

        onTapDoneCalledWith = (controller, result)
    }
}

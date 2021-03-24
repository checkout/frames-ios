//
//  StubCardViewControllerDelegate.swift
//  FramesIosTests
//
//  Created by Daven.Gomes on 12/01/2021.
//  Copyright © 2021 Checkout. All rights reserved.
//

import Frames

final class StubCardViewControllerDelegate: CardViewControllerDelegate {

    private(set) var onSubmitCalledWith: CardViewController?

    func onSubmit(controller: CardViewController) {
        onSubmitCalledWith = controller
    }

    private(set) var onTapDoneCalledWith: (controller: CardViewController,
                                           cardToken: CkoCardTokenResponse?,
                                           status: CheckoutTokenStatus)?

    func onTapDone(controller: CardViewController,
                   cardToken: CkoCardTokenResponse?,
                   status: CheckoutTokenStatus) {

        onTapDoneCalledWith = (controller, cardToken, status)
    }
}

import CheckoutEventLoggerKit

extension CheckoutEventLogging {

    func log(_ framesLogEvent: FramesLogEvent) {

        framesLogEvent.providingMetadata.forEach { (metadata, value) in

            self.add(metadata: metadata, value: value)
        }

        self.log(event: framesLogEvent.event)
    }
}

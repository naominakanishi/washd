import Foundation

import CoreNFC

final class NFCReader: NSObject {
    private lazy var session = NFCNDEFReaderSession(
        delegate: self,
        queue: nil,
        invalidateAfterFirstRead: false)
    
    func begin() {
        session.begin()
    }
}

extension NFCReader: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
                // Show an alert when the invalidation reason is not because of a
                // successful read during a single-tag read session, or because the
                // user canceled a multiple-tag read session from the UI or
                // programmatically using the invalidate method call.
                if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                    && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                    print("dasdadsd")
                }
            }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("GOT A MESSAGE!")
    }
}


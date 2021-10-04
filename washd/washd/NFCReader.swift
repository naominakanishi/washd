import Foundation
import CoreNFC

enum Constants {
    static let washdNFCType: Data = {
        guard let data = "washd".data(using: .utf8) else {
            preconditionFailure("We need a valid type")
        }
        return data
    }()
}

protocol NFCReaderDelegate: AnyObject {
    func handleUnexpectedError(_ error: Error)
    func created(tag: WashdTag)
    func detected(tag: WashdTag)
}

final class NFCReader: NSObject {
    private lazy var session = NFCNDEFReaderSession(
        delegate: self,
        queue: nil,
        invalidateAfterFirstRead: false)
    
    weak var delegate: NFCReaderDelegate?
    
    func begin() {
        session.begin()
    }
    
    func end() {
        session.invalidate()
    }
}

extension NFCReader: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("cu", error)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("GOT A MESSAGE!")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        tags.forEach { tag in
            session.connect(to: tag) { connectionError in
                if let error = connectionError {
                    self.delegate?.handleUnexpectedError(error)
                    return
                }
                
                tag.readNDEF { message, error in
                    if let error = error as? NFCReaderError,
                       error.code == .ndefReaderSessionErrorZeroLengthMessage { self.create(tag: tag) }
                    if let error = error {
                        self.delegate?.handleUnexpectedError(error)
                        return
                    }
                    message?.records.forEach {
                        guard let id = String(
                                data: $0.identifier,
                                encoding: .utf8),
                              $0.type == Constants.washdNFCType
                        else { return }
                        self.delegate?.detected(tag: .init(id: id))
                    }
                }
            }
        }
    }
    
    private func create(tag: NFCNDEFTag) {
        let id = UUID().uuidString
        guard let payload = "0".data(using: .utf8),
              let identifier = id.data(using: .utf8)
        else { return }
        let message = NFCNDEFMessage(records: [
            NFCNDEFPayload(
              format: .unknown,
              type: Constants.washdNFCType,
              identifier: identifier,
              payload: payload)
        ])
        tag.writeNDEF(message) { error in
            if let error = error {
                self.delegate?.handleUnexpectedError(error)
                return
            }
            self.delegate?.created(tag: .init(id: id))
        }
    }
}

struct WashdTag {
    let id: String
}

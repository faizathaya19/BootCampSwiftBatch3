import Foundation
import RxSwift
import RxCocoa
import Firebase

enum ChatScreen: Int, CaseIterable{
    case chatReceiver
    case chatSender
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .chatReceiver:
            return ChatReceiverTableViewCell.self
        case .chatSender:
            return ChatSenderTableViewCell.self
        }
    }
}

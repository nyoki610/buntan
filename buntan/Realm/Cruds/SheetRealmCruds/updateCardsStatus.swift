import Foundation
import RealmSwift

extension SheetRealmCruds {
    
    static func updateCardsStatus(
        newStatusTupleList: [(String, Int)],
        bookCategory: BookCategory
    ) -> Bool {
        
        guard let realm = tryRealm(caller: "updateCardsStatus") else { return false }
        
        do {
            try realm.write { // <--- ここで書き込みトランザクションを開始
                for (cardId, newCardStatusRawValue) in newStatusTupleList {
                    guard let objectId = try? ObjectId(string: cardId),
                          let targetCard = realm.object(ofType: RealmCard.self, forPrimaryKey: objectId) else {
                        // オブジェクトが見つからなかった場合、通常はトランザクションをキャンセルするか、
                        // その場でエラーを throw して呼び出し元に伝えるべきです。
                        // ここで return するとトランザクション全体がロールバックされます。
                        // 部分的な成功を許容するか、アトミックな更新を要求するかでロジックが変わります。
                        // 例: throw SheetCrudsError.cardNotFound(id: cardId)
                        print("Warning: Card with ID \(cardId) not found for update.") // 警告ログ
                        continue // 見つからなかったカードはスキップして他のカードの更新を続ける
                    }
                    
                    switch bookCategory {
                    case .freq:
                        targetCard.statusFreqRawValue = newCardStatusRawValue
                    case .pos:
                        targetCard.statusPosRawValue = newCardStatusRawValue
                    }
                }
            }
            return true
        } catch {
            print("Error: Realm write failed during updateCardsStatus: \(error)") // エラーログ
            return false
        }
    }
}

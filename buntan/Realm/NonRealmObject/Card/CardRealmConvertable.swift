import Foundation
import RealmSwift


extension Card: RealmConvertable {
    
    func convertToRealm() -> RealmCard {
        let realmCard = RealmCard()
        
        realmCard.index = index
        realmCard.word = word
        realmCard.posRawValue = pos.rawValue
        realmCard.phrase = phrase
        realmCard.meaning = meaning
        realmCard.sentence = sentence
        realmCard.translation = translation
        realmCard.startPosition = startPosition
        realmCard.endPosition = endPosition
        realmCard.statusFreqRawValue = statusFreq.rawValue
        realmCard.statusPosRawValue = statusPos.rawValue
        
        let realmInfoList = List<RealmInfo>()
        for info in infoList {
            let realmInfo = info.convertToRealm()
            realmInfoList.append(realmInfo)
        }
        realmCard.infoList = realmInfoList
        
        return realmCard
    }
}

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

extension Card: RealmConvertible {
    
    func toRealm(with idType: RealmIdType) throws -> RealmCard {
        let realmCard = RealmCard()
        try setId(to: realmCard, idType: idType)
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
        realmCard.infoList = try getRealmInfoList(from: infoList, with: idType)
        return realmCard
    }
    
    private func getRealmInfoList(from infoList: [Info], with idType: RealmIdType) throws -> List<RealmInfo> {
        let realmInfos = try infoList.map { try $0.toRealm(with: idType) }
        let realmInfoList = List<RealmInfo>()
        realmInfoList.append(objectsIn: realmInfos)
        return realmInfoList
    }
}

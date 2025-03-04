/*
 ZStack {
     
     VStack {
         
         LearnHeader(geometry,
                     isBookView)
         .padding(.bottom, 20)
         
         if learnManager.showSentence {
             sentenceCardView
                 .padding(.top, 20)
         }
         
         Spacer()
         
         wordCardView

         Spacer()
         
         LearnButton(isBookView)
     }
     
     /*
     LearnSetting(viewType: .swipe,
                  isBookView: isBookView,
                  isSetting: $isSetting,
                  cards: isBookView ? bookSharedData.cards : checkSharedData.cards,
                  options: isBookView ? bookSharedData.options : nil)
      */
 }
 */

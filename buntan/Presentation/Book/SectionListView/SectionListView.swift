//
//  SectionListView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/05.
//

import SwiftUI

struct SectionListView: View {

    @State private var viewModel: SectionListViewViewModel
    
    init(viewModel: SectionListViewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        VStack {
            Header(
                navigator: viewModel.argument.navigator,
                title: (viewModel.argument.userInput.selectedGrade?.title ?? "") + "   " + (viewModel.state.book?.title ?? "")
            )
            
            Spacer()
            
            if let book = viewModel.state.book {
                listView(book: book)
            }
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.send(.task)
        }
    }

    private func listView(book: Book) -> some View {
        
        ZStack {
            CustomScroll({
                VStack {
                    ForEach(book.sections, id: \.self) { section in
                        selectSectionButton(section: section)
                    }
                }
            }, paddingBottom: 100)
        }
    }
    
    private func selectSectionButton(section: Section) -> some View {
        
        Button {
            viewModel.send(.sectionButtonTapped(section))
        } label: {
            HStack {
                
                Text(section.title)
                    .font(.system(size: responsiveSize(16, 20)))
                Spacer()
                
                var progressLabel: String {
                    guard let category = viewModel.argument.userInput.selectedBookCategory else {
                        return ""
                    }
                    return "\(section.progressPercentage(category))"
                }
                
                Text("\(progressLabel) %")
                    .font(.system(size: responsiveSize(14, 18)))
                    .padding(.trailing, 30)
                
                Text("\(section.cards.count) words")
                    .font(.system(size: responsiveSize(14, 18)))
                    .frame(width: responsiveSize(80, 92))
                
                Image(systemName: "chevron.right.2")
                    
            }
            .foregroundColor(.black)
            .fontWeight(.bold)
            .padding(.horizontal, 20)
            .padding(.vertical, responsiveSize(16, 24))
            .background(.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black.opacity(0.3))
            )
        }
        // 場合分けしたい？
        .buttonStyle(.plain)
        .padding(.horizontal, responsiveSize(30, 100))
        .padding(.vertical, 4)
    }
}

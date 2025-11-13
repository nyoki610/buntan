//
//  BookView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/05.
//

import SwiftUI

struct BookView: View {
    
    @State private var viewModel: BookViewViewModel
    
    init(viewModel: BookViewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        NavigationStack(path: $viewModel.argument.navigator.path) {
        
            ZStack {
            
                VStack(spacing: 0) {
                    
                    if let todaysWordCount = viewModel.state.todaysWordCount {
                        headerView(todaysWordCount: todaysWordCount)
                            .padding(.top, 40)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    eachGradeView(grade: .first)
                    
                    Spacer()
                    
                    Text("\\          New !          /")
                        .padding(.bottom, 12)
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.6))
                        .font(.system(size: 18))
                    
                    eachGradeView(grade: .preFirst)

                    Spacer()
                    
                    Text("各単語の例文は随時追加中！")
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.6))
                        .font(.system(size: 18))
                    
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationDestination(for: BookViewName.self) { viewName in
                viewName.viewForName(
                    navigator: viewModel.argument.navigator,
                    userInput: viewModel.argument.userInput
                )
            }
            .task {
                AnalyticsLogger.logScreenTransition(viewName: MainViewName.root(.book))
                viewModel.send(.task)
            }
            .toolbar(viewModel.argument.navigator.path.isEmpty ? .visible : .hidden, for: .tabBar)
        }
    }
    
    private func headerView(todaysWordCount: Int) -> some View {
        
        HStack {
            VStack {
                Text("今日の")
                Text("学習単語")
            }
            .font(.system(size: responsiveSize(14, 20)))
            
            Image(systemName: "chart.bar.fill",
                  variableValue: viewModel.state.variableValue)
            .font(.system(size: responsiveSize(30, 40)))
            .foregroundStyle(Orange.defaultOrange)
            
            Text("\(todaysWordCount) words")
                .padding(.top, 10)
                .font(.system(size: responsiveSize(17, 24)))

            Spacer()
        }
        .fontWeight(.bold)
        .padding(.vertical, 10)
        .padding(.horizontal, 40)
    }

    private func eachGradeView(grade: EikenGrade) -> some View {
        
        VStack(spacing: 0) {
            Text(grade.title)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.system(size: responsiveSize(20, 28)))
                .padding(.top, 20)
                
            HStack {
                Spacer()
                selectBookCategoryButton(grade: grade, bookCategory: .freq)
                Spacer()
                selectBookCategoryButton(grade: grade, bookCategory: .pos)
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .foregroundColor(.black)
        .background(grade.color)
        .cornerRadius(10)
        .padding(.horizontal, responsiveSize(10, 60))
    }
    
    private func selectBookCategoryButton(grade: EikenGrade, bookCategory: BookCategory) -> some View {
                
        Button {
            viewModel.send(.bookCategoryButtonTapped(grade: grade, category: bookCategory))
        } label: {
            HStack {
                Text(bookCategory.buttonLabel)
                    .padding(.trailing, 10)
                Image(systemName: "chevron.right.2")
            }
            .fontWeight(.heavy)
            .font(.system(size: responsiveSize(18, 24)))
            .frame(width: responsiveSize(160, 240), height: responsiveSize(50, 70))
            .background(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    BookView(
        viewModel: BookViewViewModel(
            argument: .init(navigator: BookNavigator(), userInput: BookUserInput())
        )
    )
}

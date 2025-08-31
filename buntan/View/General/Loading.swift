import SwiftUI

struct LoadingView: View {

    let status: LoadingSharedData.Status

    var body: some View {
            
        VStack {
            
            switch status {
                
            case .loading(let label):
                loadingView(label: label)
                
            case .completed:
                completedView
            }
        }
        .padding()
        .frame(width: responsiveSize(140, 200), height: responsiveSize(100, 160))
        .background(.white)
        .cornerRadius(10)
    }
    
    private func loadingView(label: String) -> some View {
        
        Group {
            ProgressView()
                .scaleEffect(responsiveSize(1.5, 2.0))
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            
            Text(label)
                .fontSize(responsiveSize(14, 20))
                .bold()
                .padding(.top, responsiveSize(10, 32))
        }
    }
    
    private var completedView: some View {
        
        Group {
            Spacer()

            Image(systemName: "checkmark.circle")
                .font(.system(size: responsiveSize(60, 100)))
                .foregroundColor(.green.opacity(0.5))
                
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
    }
}


struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            
            VStack {
                Spacer()
                LoadingView(status: .loading(label: "データ取得中..."))
                Spacer()
                LoadingView(status: .completed)
                Spacer()
            }
        }
    }
}

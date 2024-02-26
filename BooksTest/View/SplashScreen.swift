//
//  SplashScreen.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 22.02.2024.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var progress = 0.0
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("splash_back")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            Image("splash_hearts")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            VStack {
                Text("Book App")
                    .italic()
                    .font(.custom("Georgia", fixedSize: 52))
                    .foregroundColor(Color(hex: "DD48A1"))
                Text("Welcome to Book App")
                    .font(.custom("Nunito Sans", fixedSize: 24))
                    .foregroundColor(Color(hex: "FFFFFF").opacity(0.8))
                    .padding(.bottom)
                ProgressView(value: progress, total: 100)
                    .tint(.white)
                    .onReceive(timer) { _ in
                        if progress < 100 {
                            progress += 20
                        }
                    }
                    .padding([.leading, .trailing], 44)
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

import SwiftUI

struct Activity: View {
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack(spacing: 8){
                HStack(spacing: 170 ){
                    Text("Activity")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 15){
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 23))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(.gray1))
                            .overlay(
                                Circle().stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.5), .white.opacity(0.05)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1
                                )
                            )
                            .shadow(color: .black.opacity(0.5), radius: 10, y: 0)
                        
                        Image(systemName: "pencil.and.outline")
                            .font(.system(size: 23))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(.gray1))
                            .overlay(
                                Circle().stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.5), .white.opacity(0.05)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1
                                )
                            )
                            .shadow(color: .black.opacity(0.5), radius: 10, y: 0)
                        
                    }
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading){
                    Text("Thursday, 24 October")
                        .foregroundStyle(.gray)
                        
                }.frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(height: 10)

                HStack(spacing: 46){
                    Text("S")
                    Text("M")
                    Text("T")
                    Text("W")
                    Text("T")
                    Text("F")
                    Text("S")
                }.foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                
                HStack(spacing: 16){
                    
                    Circle()
                        .fill(.orange2)
                        .frame(width: 40 , height: 40)
                        .overlay{
                            Text("20")
                                .foregroundStyle(.orange1)
                            
                        }
                    Circle()
                        .fill(.orange2)
                        .frame(width: 40 , height: 40)
                        .overlay{
                            Text("20")
                                .foregroundStyle(.orange1)
                            
                        }
                    Circle()
                        .fill(.orange2)
                        .frame(width: 40 , height: 40)
                        .overlay{
                            Text("20")
                                .foregroundStyle(.orange1)
                            
                        }
                    Circle()
                        .fill(.orange2)
                        .frame(width: 40 , height: 40)
                        .overlay{
                            Text("20")
                                .foregroundStyle(.orange1)
                            
                        }
                    Circle()
                        .fill(.orange2)
                        .frame(width: 40 , height: 40)
                        .overlay{
                            Text("20")
                                .foregroundStyle(.orange1)
                            
                        }
                    Circle()
                        .fill(.orange2)
                        .frame(width: 40 , height: 40)
                        .overlay{
                            Text("20")
                                .foregroundStyle(.orange1)
                            
                        }
                    
                    Circle()
                        .fill(.orange2)
                        .frame(width: 40 , height: 40)
                        .overlay{
                            Text("20")
                                .foregroundStyle(.orange1)
                            
                        }
                        
                }

                
                
                
               Spacer()
                
                
               
            }//V
        }//z

    }
}

#Preview {
    Activity()
    
        
}


import SwiftUI

struct Onboarding: View {
    @StateObject private var viewModel = OnboardingViewModel()
    var onStart: (LearningGoal) -> Void = { _ in }

    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()

            VStack(){

                VStack{
                    Spacer().frame(height: 70)

                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange1)
                        .font(.system(size: 45))

                    Spacer().frame(height: 70)
                }

                VStack(alignment: .leading , spacing: 10){
                    Text("Hello ").fontWeight(.light).font(.system(size: 34)) + Text("Learner").fontWeight(.bold)
                        .font(.system(size: 34))

                    Text("This app will help you learn everyday!")
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading){
                    Spacer().frame(height: 35)

                    Text("I want to learn")

                    TextField("Topic", text: $viewModel.topic, prompt: Text("Swift").foregroundStyle(.gray))

                    Divider().background(Color.gray)

                }.frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading){

                    Spacer().frame(height: 25)

                    Text("I want to learn it in a")

                    HStack(spacing: 12) {
                        durationButton("Week", duration: .week)
                        durationButton("Month", duration: .month)
                        durationButton("Year", duration: .year)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 23))
                        .frame(maxWidth: .infinity, alignment: .leading)

                } .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .center , spacing: 10){
                    Spacer()

                    Button{
                        if let goal = viewModel.createGoal() {
                            onStart(goal)
                        }
                    } label: {
                        Text("Start Learning")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .frame(width: 170 , height:  45)
                            .glass(Capsule(), fill: .orange1)
                    }
                    .buttonStyle(.plain)

                    Text("You can edit your desire later")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }

            }.foregroundStyle(.white)
                .padding(.horizontal, 20)
        }
    }

    private func durationButton(
        _ title: String,
        duration: GoalDuration
    ) -> some View {
        let isSelected = viewModel.duration == duration

        return Button {
            viewModel.duration = duration
        } label: {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(isSelected ? .white : .gray)
                .padding(.horizontal, 21)
                .frame(height: 45)
                .glass(Capsule(), fill: isSelected ? .orange1 : .gray1)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Onboarding()
}

import SwiftUI

struct Activity: View {

    @StateObject private var viewModel: ActivityViewModel
    @State private var showUpdateGoal = false
    @State private var outcome: GoalOutcome? = nil
    @State private var needsUpdateConfirmation = true
    @State private var showCalendar = false
    
    init(goal: LearningGoal) {
        self.goal = goal
        _viewModel = StateObject(
            wrappedValue: ActivityViewModel(goal: goal)
        )
    }
    let goal: LearningGoal

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

                        Button{
                            showCalendar = true
                        } label: {
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
                        }

                        Button{
                            needsUpdateConfirmation = true
                            showUpdateGoal = true

                        } label: {
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

                    }

                }.frame(maxWidth: .infinity, alignment: .leading)

                Text(viewModel.dateText)
                    .font(.system(size: 17))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { index in
                        VStack(spacing: 8) {
                            Text(viewModel.weekdayLetters[index])
                                .font(.system(size: 13))
                                .foregroundStyle(.white)

                            let date = viewModel.weekDates[index]
                            let todayColor: Color = viewModel.todayStatus == .frozen ? .cyan : .orange1

                            Text(date.formatted(.dateTime.day()))
                                .font(.system(size: 17))
                                .foregroundStyle(viewModel.isToday(date) ? .white : .white)
                                .frame(width: 44, height: 44)
                                .background {
                                    if viewModel.isToday(date) {
                                        Circle().fill(todayColor)                                    }
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                HStack(spacing: 12) {
                    statCard(
                        symbol: "flame.fill",
                        color: .orange1,
                        count: viewModel.learnedDays,
                        title: "Learned"
                    )

                    statCard(
                        symbol: "snowflake",
                        color: .cyan,
                        count: viewModel.freezedDays,
                        title: "Freezed"
                    )
                }
                Spacer(minLength: 32)

                switch outcome {
                    case .completed:
                        GoalResult(
                            symbol: "hands.clap.fill",
                            title: "Will done!",
                            subtitle: "Ready for your next goal?",
                            onSetGoal: {
                                needsUpdateConfirmation = false
                                showUpdateGoal = true
                            }                        )

                    case .failed:
                        GoalResult(
                            symbol: "xmark.seal.fill",
                            title: "You didn't reach your goal this time.",
                            subtitle: "Want to set another goal?",
                            onSetGoal: {
                                needsUpdateConfirmation = false
                                showUpdateGoal = true
                            }                        )

                  
                case nil:
                    Button {
                        viewModel.logLearnedToday()
                    } label: {
                        Circle()
                            .fill(viewModel.canLogLearnedToday ? .orange1 : .gray1)
                            .frame(width: 270, height: 270)
                            .overlay {
                                Text(
                                    viewModel.canLogLearnedToday
                                    ? "Log as Learned"
                                    : "Logged as Learned"
                                )
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                            }
                    }
                    .buttonStyle(.plain)
                    .disabled(!viewModel.canLogLearnedToday)

                    Spacer()

                    Button {
                        viewModel.freezeToday()
                    } label: {
                        Text(viewModel.todayStatus == .frozen ? "Freezed for a day" : "Freeze for a day")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(
                                Capsule()
                                    .fill(viewModel.canFreezeToday ? .cyan : .gray1)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!viewModel.canFreezeToday)

                    Text("\(viewModel.freezedDays) out of \(viewModel.freezeLimit) Freezes used")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }

                Spacer()
            }//V
        }//z
        .navigationDestination(isPresented: $showUpdateGoal) {
            UpdateGoal(
                goal: viewModel.goal,
                needsConfirmation: needsUpdateConfirmation
            ) { updatedGoal in
                viewModel.updateGoal(updatedGoal)
            }
        }
        .navigationDestination(isPresented: $showCalendar) {
            ActivityCalendar(activityViewModel: viewModel)
        }
    }

    private func statCard(
        symbol: String,
        color: Color,
        count: Int,
        title: String
    ) -> some View {
        VStack(spacing: 6) {
            Image(systemName: symbol)
                .foregroundStyle(color)

            Text("\(count) \(count == 1 ? "day" : "days")")
                .foregroundStyle(.white)

            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 94)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.gray1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.25), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        Activity(
            goal: LearningGoal(
                topic: "Swift",
                duration: .week,
                startDate: .now
            )
        )
    }
}

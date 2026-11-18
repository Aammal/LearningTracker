import SwiftUI
import Combine

struct Activity: View {

    @StateObject private var viewModel: ActivityViewModel
    @State private var showUpdateGoal = false
    @State private var needsUpdateConfirmation = true
    @State private var showCalendar = false
    @Environment(\.scenePhase) private var scenePhase

    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    init(goal: LearningGoal) {
        _viewModel = StateObject(
            wrappedValue: ActivityViewModel(goal: goal)
        )
    }

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
                                .glass(Circle(), fill: .gray1)
                        }
                        .buttonStyle(.plain)

                        Button{
                            needsUpdateConfirmation = true
                            showUpdateGoal = true
                        } label: {
                            Image(systemName: "pencil.and.outline")
                                .font(.system(size: 23))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .glass(Circle(), fill: .gray1)
                        }
                        .buttonStyle(.plain)

                    }

                }.frame(maxWidth: .infinity, alignment: .leading)

                Text(viewModel.dateText)
                    .font(.system(size: 17))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { index in
                        let date = viewModel.weekDates[index]
                        let colors = dayColors(for: date)

                        VStack(spacing: 8) {
                            Text(viewModel.weekdayLetters[index])
                                .font(.system(size: 13))
                                .foregroundStyle(.white)

                            Text(date.formatted(.dateTime.day()))
                                .font(.system(size: 17))
                                .foregroundStyle(colors.text)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(colors.circle))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                HStack(spacing: 10) {
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

                switch viewModel.outcome {
                case .completed:
                    GoalResult(
                        symbol: "hands.clap.fill",
                        title: "Will done!",
                        subtitle: "Ready for your next goal?",
                        onSetGoal: {
                            needsUpdateConfirmation = false
                            showUpdateGoal = true
                        }
                    )

                case .failed:
                    GoalResult(
                        symbol: "xmark.seal.fill",
                        title: "You didn't reach your goal this time.",
                        subtitle: "Want to set another goal?",
                        onSetGoal: {
                            needsUpdateConfirmation = false
                            showUpdateGoal = true
                        }
                    )

                case nil:
                    Button {
                        viewModel.logLearnedToday()
                    } label: {
                        Text(
                            viewModel.canLogLearnedToday
                            ? "Log as Learned"
                            : "Logged as Learned"
                        )
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(viewModel.canLogLearnedToday ? .white : .gray)
                        .frame(width: 272, height: 272)                        .glass(Circle(), fill: viewModel.canLogLearnedToday ? .orange1 : .gray1 , shine: 0.08)
                    }
                    .buttonStyle(.plain)
                    .disabled(!viewModel.canLogLearnedToday)

                    Spacer()

                    Button {
                        viewModel.freezeToday()
                    } label: {
                        Text(viewModel.canFreezeToday ? "Freeze for a day" : "Freezed for a day")
                            .font(.system(size: 16))
                            .foregroundStyle(viewModel.canFreezeToday ? .white : .gray)
                            .frame(width: 272, height: 44)
                            .glass(Capsule(), fill: viewModel.canFreezeToday ? .cyan : .gray1)
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
        .onAppear {
            viewModel.refresh()
        }
        .onReceive(timer) { _ in
            viewModel.refresh()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.refresh()
            }
        }
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

    private func dayColors(for date: Date) -> (circle: Color, text: Color) {
        let status = viewModel.status(for: date)

        if viewModel.isToday(date) && status == nil {
            return (.orange1, .white)
        } else if status == .learned {
            return (.orange2, .orange1)
        } else if status == .frozen {
            return (Color.cyan.opacity(0.2), .cyan)
        } else {
            return (.clear, .white)
        }
    }

    private func statCard(
        symbol: String,
        color: Color,
        count: Int,
        title: String
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: 30, style: .continuous)

        return VStack(spacing: 6) {
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
        .background {
            shape.fill(Color.white.opacity(0.10))
        }
        .overlay {
            shape.strokeBorder(
                LinearGradient(
                    colors: [
                        .white.opacity(0.30),
                        .white.opacity(0.08),
                        .white.opacity(0.18)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
        }
        .shadow(color: .black.opacity(0.28), radius: 12, x: 0, y: 7)
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

import SwiftUI

struct UpdateGoal: View {
    @StateObject private var viewModel: UpdateGoalViewModel
    @Environment(\.dismiss) private var dismiss
    let needsConfirmation: Bool
    let onUpdate: (LearningGoal) -> Void

    @State private var showResetAlert = false
    @State private var updatedGoal: LearningGoal?

    init(
        goal: LearningGoal,
        needsConfirmation: Bool = true,
        onUpdate: @escaping (LearningGoal) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: UpdateGoalViewModel(goal: goal)
        )
        self.needsConfirmation = needsConfirmation
        self.onUpdate = onUpdate
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // العنوان وزر الرجوع والحفظ
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(.gray1))
                    }

                    Spacer()

                    Text("Learning Goal")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)

                    Spacer()

                    Button {
                        updatedGoal = viewModel.makeUpdatedGoal()

                        if let goal = updatedGoal {
                            if needsConfirmation {
                                showResetAlert = true
                            } else {
                                onUpdate(goal)
                                dismiss()
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(.orange1))
                    }
                    .disabled(
                        viewModel.topic
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .isEmpty
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn")
                        .foregroundStyle(.white)

                    TextField("Topic", text: $viewModel.topic)
                        .foregroundStyle(.white)

                    Divider()
                        .overlay(.gray)
                }
                .padding(.top, 55)

                VStack(alignment: .leading, spacing: 16) {
                    Text("I want to learn it in a")
                        .foregroundStyle(.white)

                    HStack(spacing: 12) {
                        durationButton("Week", duration: .week)
                        durationButton("Month", duration: .month)
                        durationButton("Year", duration: .year)
                    }
                }
                .padding(.top, 35)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .alert("Update goal", isPresented: $showResetAlert) {
            Button("Dismiss", role: .cancel) {
                updatedGoal = nil
            }

            Button("Update") {
                if let updatedGoal {
                    onUpdate(updatedGoal)
                    dismiss()
                }
            }
        } message: {
            Text("If you update now, your streak will start over.")
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func durationButton(
        _ title: String,
        duration: GoalDuration
    ) -> some View {
        let isSelected = viewModel.duration == duration
        let shape = Capsule()

        return Button {
            viewModel.duration = duration
        } label: {
            Text(title)
                .font(.system(size: 17))
                .foregroundStyle(isSelected ? .white : .gray)
                .frame(width: 95, height: 45)
                .background {
                    shape.fill(isSelected ? Color.orange1 : Color.gray1)
                }
                .overlay {
                    shape.strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.38),
                                .white.opacity(0.08),
                                .white.opacity(0.18)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
                }
        }
        .buttonStyle(.plain)
    }
}


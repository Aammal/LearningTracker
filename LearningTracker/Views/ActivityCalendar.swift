import SwiftUI

struct ActivityCalendar: View {
    @ObservedObject var activityViewModel: ActivityViewModel
    @StateObject private var viewModel = ActivityCalendarViewModel()
    @Environment(\.dismiss) private var dismiss

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            ForEach(viewModel.months, id: \.self) { month in
                                monthSection(month)
                                    .id(month)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .onAppear {
                        proxy.scrollTo(viewModel.currentMonth, anchor: .top)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
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

            Text("Activities")
                .foregroundStyle(.white)
                .fontWeight(.semibold)

            Spacer()

            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    private func monthSection(_ month: Date) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.title(for: month))
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.weekdayHeaders, id: \.self) { header in
                    Text(header)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.gray)
                }

                let cells = viewModel.cells(for: month)
                ForEach(cells.indices, id: \.self) { index in
                    if let date = cells[index] {
                        dayCell(date)
                    } else {
                        Color.clear.frame(height: 44)
                    }
                }
            }
        }
    }

    private func dayCell(_ date: Date) -> some View {
        let status = activityViewModel.status(for: date)
        let isToday = activityViewModel.isToday(date)

        var background: Color = .clear
        var textColor: Color = .white

        if isToday {
            background = status == .frozen ? .cyan : .orange1
        } else if status == .learned {
            background = .orange2
            textColor = .orange1
        } else if status == .frozen {
            background = Color.cyan.opacity(0.2)
            textColor = .cyan
        }

        return Text(date.formatted(.dateTime.day()))
            .font(.system(size: 17))
            .foregroundStyle(textColor)
            .frame(width: 44, height: 44)
            .background(Circle().fill(background))
    }
}

#Preview {
    NavigationStack {
        ActivityCalendar(
            activityViewModel: ActivityViewModel(
                goal: LearningGoal(
                    topic: "Swift",
                    duration: .week,
                    startDate: .now
                )
            )
        )
    }
}

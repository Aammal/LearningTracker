import SwiftUI

struct GoalResult: View {
    let symbol: String
    let title: String
    let subtitle: String
    let onSetGoal: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.system(size: 44))
                .foregroundStyle(.orange1)

            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.system(size: 15))
                .foregroundStyle(.gray)

            Button(action: onSetGoal) {
                Capsule()
                    .fill(.orange1)
                    .frame(width: 140, height: 46)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil.and.outline")
                            Text("Set a goal")
                        }
                        .foregroundStyle(.white)
                    }
            }
            .buttonStyle(.plain)
            .padding(.top, 32)
        }
    }
}

#Preview("Completed") {
    ZStack {
        Color.black.ignoresSafeArea()
        GoalResult(
            symbol: "hands.clap.fill",
            title: "Will done!",
            subtitle: "Ready for your next goal?",
            onSetGoal: {}
        )
    }
}

#Preview("Not reached") {
    ZStack {
        Color.black.ignoresSafeArea()
        GoalResult(
            symbol: "xmark.seal.fill",
            title: "You didn't reach your goal this time.",
            subtitle: "Want to set another goal?",
            onSetGoal: {}
        )
    }
}

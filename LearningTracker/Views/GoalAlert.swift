import SwiftUI

struct GoalAlert: View {
    let title: String
    let message: String
    let onDismiss: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)

            Text(message)
                .font(.system(size: 15))
                .foregroundStyle(.gray)

            HStack(spacing: 12) {
                Button(action: onDismiss) {
                    Text("Dismiss")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .glass(Capsule(), fill: .gray1)
                }
                .buttonStyle(.plain)

                Button(action: onConfirm) {
                    Text("Update")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .glass(Capsule(), fill: .orange1)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 16)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glass(
            RoundedRectangle(cornerRadius: 28, style: .continuous),
            fill: .gray1,
            shine: 0.02,
            rim: 0.10,
            glow: 0
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        GoalAlert(
            title: "Update goal",
            message: "If you update now, your streak will start over.",
            onDismiss: {},
            onConfirm: {}
        )
        .padding(.horizontal, 40)
    }
}

import SwiftUI

struct GlassBackground<S: InsettableShape>: ViewModifier {
    let shape: S
    let fill: Color
    var shine: Double
    var rim: Double
    var glow: Double

    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    shape.fill(fill)
                    shape.fill(
                        LinearGradient(
                            colors: [.white.opacity(shine), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                }
            }
            .overlay {
                shape.strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(rim),
                            .white.opacity(rim * 0.2),
                            .white.opacity(rim * 0.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
            }
            .shadow(color: fill.opacity(glow), radius: 8, x: 0, y: 3)
    }
}

extension View {
    func glass<S: InsettableShape>(
        _ shape: S,
        fill: Color,
        shine: Double = 0.05,
        rim: Double = 0.22,
        glow: Double = 0.12
    ) -> some View {
        modifier(
            GlassBackground(
                shape: shape,
                fill: fill,
                shine: shine,
                rim: rim,
                glow: glow
            )
        )
    }
}

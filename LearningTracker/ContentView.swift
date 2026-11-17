import SwiftUI

struct ContentView: View {
    @State private var learningGoal: LearningGoal?

    var body: some View {
        NavigationStack {
            if let goal = learningGoal {
                Activity(goal: goal)
            } else {
                Onboarding { goal in
                    learningGoal = goal
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

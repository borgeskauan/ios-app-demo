import SwiftUI

struct CalculatorButton: View {
  let label: String
  let action: () -> Void

  @State private var isPressed = false

  var backgroundColor: Color {
    switch label {
    case "÷", "×", "-", "+", "=":
      return Color(UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1))
    case "C", "+/-", "%":
      return Color(UIColor(red: 0.55, green: 0.35, blue: 0.75, alpha: 1))
    default:
      return Color(UIColor(red: 0.25, green: 0.25, blue: 0.4, alpha: 1))
    }
  }

  var body: some View {
    Button(action: {
      withAnimation(.easeInOut(duration: 0.1)) {
        isPressed = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        action()
        withAnimation(.easeInOut(duration: 0.1)) {
          isPressed = false
        }
      }
    }) {
      Text(label)
        .font(.system(size: 26, weight: .semibold, design: .rounded))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [
              backgroundColor,
              backgroundColor.opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .cornerRadius(18)
        .shadow(
          color: backgroundColor.opacity(0.5),
          radius: isPressed ? 5 : 12,
          x: 0,
          y: isPressed ? 2 : 6
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .opacity(isPressed ? 0.9 : 1.0)
    }
  }
}

#Preview {
  CalculatorButton(label: "5", action: {})
}

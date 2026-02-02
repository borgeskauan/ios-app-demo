import SwiftUI

struct CalculatorButton: View {
  let label: String
  let action: () -> Void

  var backgroundColor: Color {
    switch label {
    case "÷", "×", "-", "+", "=":
      return Color.orange
    case "C", "+/-", "%":
      return Color(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
    default:
      return Color(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1))
    }
  }

  var body: some View {
    Button(action: action) {
      Text(label)
        .font(.system(size: 24, weight: .semibold))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(backgroundColor)
        .cornerRadius(10)
    }
  }
}

#Preview {
  CalculatorButton(label: "5", action: {})
}

import SwiftUI

struct CalculatorView: View {
  @State private var display = "0"
  @State private var previousValue = 0.0
  @State private var operation: String? = nil
  @State private var isNewInput = true

  let buttons: [[String]] = [
    ["C", "+/-", "%", "÷"],
    ["7", "8", "9", "×"],
    ["4", "5", "6", "-"],
    ["1", "2", "3", "+"],
    ["0", ".", "="]
  ]

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack(spacing: 12) {
        // Display
        VStack(alignment: .trailing) {
          Text(display)
            .font(.system(size: 60, weight: .light))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        .background(Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
        .cornerRadius(10)

        // Buttons
        VStack(spacing: 12) {
          ForEach(buttons, id: \.self) { row in
            HStack(spacing: 12) {
              if row.count == 4 {
                ForEach(row, id: \.self) { button in
                  CalculatorButton(label: button, action: {
                    handleButtonTap(button)
                  })
                }
              } else if row.count == 3 {
                ForEach(row, id: \.self) { button in
                  CalculatorButton(label: button, action: {
                    handleButtonTap(button)
                  })
                }
                Spacer()
              }
            }
          }
        }
        .padding()
        .background(Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)))
        .cornerRadius(10)

        Spacer()
      }
      .padding()
    }
  }

  private func handleButtonTap(_ button: String) {
    switch button {
    case "C":
      display = "0"
      previousValue = 0
      operation = nil
      isNewInput = true

    case "=":
      if let op = operation {
        let currentValue = Double(display) ?? 0
        let result = calculate(previousValue, currentValue, op)
        display = formatResult(result)
        previousValue = result
        operation = nil
        isNewInput = true
      }

    case "+", "-", "×", "÷":
      let currentValue = Double(display) ?? 0
      if let op = operation {
        let result = calculate(previousValue, currentValue, op)
        display = formatResult(result)
        previousValue = result
      } else {
        previousValue = currentValue
      }
      operation = button
      isNewInput = true

    case "+/-":
      if let value = Double(display) {
        display = formatResult(-value)
      }

    case "%":
      if let value = Double(display) {
        display = formatResult(value / 100)
      }

    case ".":
      if !display.contains(".") {
        display += "."
        isNewInput = false
      }

    default:
      if isNewInput {
        display = button
        isNewInput = false
      } else {
        if display == "0" && button != "0" {
          display = button
        } else if display != "0" {
          display += button
        }
      }
    }
  }

  private func calculate(_ a: Double, _ b: Double, _ op: String) -> Double {
    switch op {
    case "+": return a + b
    case "-": return a - b
    case "×": return a * b
    case "÷": return b != 0 ? a / b : 0
    default: return b
    }
  }

  private func formatResult(_ value: Double) -> String {
    if value.truncatingRemainder(dividingBy: 1) == 0 {
      return String(Int(value))
    }
    return String(format: "%.2f", value).replacingOccurrences(of: ",", with: ".")
  }
}

#Preview {
  CalculatorView()
}

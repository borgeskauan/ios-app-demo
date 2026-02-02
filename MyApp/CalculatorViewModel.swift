import SwiftUI

class CalculatorViewModel: ObservableObject {
  @Published var display = "0"
  @Published var previousValue = 0.0
  @Published var operation: String? = nil
  @Published var isNewInput = true

  func handleButtonTap(_ button: String) {
    switch button {
    case "C":
      clear()
    case "=":
      calculate()
    case "+", "-", "×", "÷":
      setOperation(button)
    case "+/-":
      toggleSign()
    case "%":
      percentage()
    case ".":
      addDecimal()
    default:
      appendDigit(button)
    }
  }

  private func clear() {
    display = "0"
    previousValue = 0
    operation = nil
    isNewInput = true
  }

  private func calculate() {
    if let op = operation {
      let currentValue = Double(display) ?? 0
      let result = performCalculation(previousValue, currentValue, op)
      display = formatResult(result)
      previousValue = result
      operation = nil
      isNewInput = true
    }
  }

  private func setOperation(_ op: String) {
    let currentValue = Double(display) ?? 0
    if let currentOp = operation {
      let result = performCalculation(previousValue, currentValue, currentOp)
      display = formatResult(result)
      previousValue = result
    } else {
      previousValue = currentValue
    }
    operation = op
    isNewInput = true
  }

  private func toggleSign() {
    if let value = Double(display) {
      display = formatResult(-value)
    }
  }

  private func percentage() {
    if let value = Double(display) {
      display = formatResult(value / 100)
    }
  }

  private func addDecimal() {
    if !display.contains(".") {
      display += "."
      isNewInput = false
    }
  }

  private func appendDigit(_ digit: String) {
    if isNewInput {
      display = digit
      isNewInput = false
    } else {
      if display == "0" && digit != "0" {
        display = digit
      } else if display != "0" {
        display += digit
      }
    }
  }

  private func performCalculation(_ a: Double, _ b: Double, _ op: String) -> Double {
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

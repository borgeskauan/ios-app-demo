import SwiftUI

struct CalculatorView: View {
  @StateObject private var viewModel = CalculatorViewModel()

  let buttons: [[String]] = [
    ["C", "+/-", "%", "÷"],
    ["7", "8", "9", "×"],
    ["4", "5", "6", "-"],
    ["1", "2", "3", "+"],
    ["0", ".", "="]
  ]

  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [
          Color(UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1)),
          Color(UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 1))
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack(spacing: 20) {
        // Header
        VStack(alignment: .center, spacing: 4) {
          Text("Calculator")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)

        // Display
        VStack(alignment: .trailing) {
          Text(viewModel.display)
            .font(.system(size: 70, weight: .thin, design: .default))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .tracking(1)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .frame(height: 120)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [
              Color(UIColor(red: 0.15, green: 0.1, blue: 0.25, alpha: 1)),
              Color(UIColor(red: 0.1, green: 0.08, blue: 0.2, alpha: 1))
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 16)

        // Buttons
        VStack(spacing: 14) {
          ForEach(buttons, id: \.self) { row in
            HStack(spacing: 14) {
              if row.count == 4 {
                ForEach(row, id: \.self) { button in
                  CalculatorButton(label: button, action: {
                    viewModel.handleButtonTap(button)
                  })
                }
              } else if row.count == 3 {
                ForEach(row, id: \.self) { button in
                  CalculatorButton(label: button, action: {
                    viewModel.handleButtonTap(button)
                  })
                }
                Spacer()
              }
            }
          }
        }
        .padding(16)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [
              Color(UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1)),
              Color(UIColor(red: 0.06, green: 0.06, blue: 0.1, alpha: 1))
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 16)

        Spacer()
      }
      .padding(.bottom, 20)
    }
  }
}

#Preview {
  CalculatorView()
}

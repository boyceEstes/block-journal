//
//  HabitsMenu.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 1/21/24.
//

import SwiftUI


struct ActionDetail: Hashable {
    
    let title: String
    let role: ButtonRole?
    let action: () -> Void
    
    
    init(title: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.role = role
        self.action = action
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    
    public static func == (lhs: ActionDetail, rhs: ActionDetail) -> Bool {
        lhs.title == rhs.title
    }
    
    
    static func ok(buttonAction: @escaping (() -> Void) = {}) -> ActionDetail {
        ActionDetail(title: "OK", action: buttonAction)
    }
    
    
    static func cancel(buttonAction: @escaping (() -> Void) = {}) -> ActionDetail {
        ActionDetail(title: "Cancel", role: .cancel, action: buttonAction)
    }
}


struct AlertDetail {
    
    let title: String
    let message: String
    let actions: [ActionDetail]
    
    
    init(title: String, message: String, actions: [ActionDetail] = [.ok()]) {
        self.title = title
        self.message = message
        self.actions = actions
    }
    
    
    static func okAlert(title: String, message: String, buttonAction: @escaping () -> Void = { }) -> AlertDetail {
        
        AlertDetail(title: title, message: message, actions: [.ok(buttonAction: buttonAction)])
    }
    
    
    static func destructiveAlert(title: String, message: String, cancelAction: @escaping () -> Void = {}, destroyTitle: String, destroyAction: @escaping () -> Void) -> AlertDetail {
        
        AlertDetail(title: title, message: message, actions: [
            .cancel(buttonAction: cancelAction),
            ActionDetail(title: destroyTitle, role: .destructive, action: destroyAction)
        ])
    }
}


extension View {
    
    @ViewBuilder
    func alert(showAlert: Binding<Bool>, alertDetail: AlertDetail?) -> some View {
        
        if let alertDetail {
            alert(
                alertDetail.title,
                isPresented: showAlert,
                presenting: alertDetail,
                actions: { data in
                    ForEach(alertDetail.actions, id: \.self) { alertAction in
                        Button(alertAction.title, role: alertAction.role, action: alertAction.action)
                    }
                }, message: { data in
                    Text(data.message)
                }
            )
        } else {
            alert("Unknown Issue", isPresented: showAlert, actions: { }, message: {
                Text("Some problem has occurred with displaying an error alert - that's weird.")
            })
        }
    }
}


enum HabitsMenuAlert {
    case areYouSure(yesAction: () -> Void)
    
    func alertData() -> AlertDetail {
        
        switch self {
        case let .areYouSure(yesAction):
            return AlertDetail.destructiveAlert(
                title: "Are you sure?",
                message: "This will delete all of the habit's associated records as well 👀",
                destroyTitle: "Destroy It All",
                destroyAction: yesAction
            )
        }
    }
}


struct HabitsMenu: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var showAlert: Bool = false
    @State private var alertDetail: AlertDetail? = nil
    
    // TODO: load habits from db
    let habits: [DataHabit]
    
    let habitMenuHeight: CGFloat
    let didTapCreateHabitButton: () -> Void
    let didTapHabitButton: (DataHabit) -> Void
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                Text("Habits")
                    .font(.title2)
                Spacer()
                Button {
                    didTapCreateHabitButton()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }
            .fontWeight(.semibold)
            .padding(.horizontal)
            .padding(.vertical, 30)
            
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 25) {
                    ForEach(0..<habits.count, id: \.self) { i in
                        
                        let habit = habits[i]
                        habitButton(habit: habit)
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
//            .frame(height: habitMenuHeight)
//            .background(Color.indigo)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 20))
        .padding()
        .alert(showAlert: $showAlert, alertDetail: alertDetail)
    }
    
    
    func habitButton(habit: DataHabit) -> some View {
        
        Button {
            didTapHabitButton(habit)
        } label: {
            Text("\(habit.name)")
                .fontWeight(.semibold)
                .font(.system(size: 17))
                .frame(width: 150, height: 50)
                .background(Color(hex: habit.color))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .contextMenu {
            NavigationLink("Habit Details") {
                HabitDetailView(habit: Habit(name: habit.name, color: Color(hex: habit.color) ?? .gray))
            }
            Button("Delete Habit") {
                alertDetail = HabitsMenuAlert.areYouSure(yesAction: {
                        modelContext.delete(habit)
                    }
                ).alertData()
                showAlert = true
            }
        }
    }
}

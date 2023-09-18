//
//  AlarmPopoverView.swift
//  Alarm
//
//  Created by Carlos Mata on 8/8/23.
//
import SwiftUI
struct AlarmPopoverView: View {
    @State var isPopoverPresented = false
    @State var alarmDate: Date = Date()
    @State var newAlarm = Alarm(date: "", ringtone: "", nameOfAlarm: "", activated: true, repeatedDays: [""])
    @State var alarms: [Alarm] = []
    @EnvironmentObject var userNotifications: UserNotifications
    private var managerAudio = ManagerAudioBackground()
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.purple]),
                startPoint: .bottomLeading,
                endPoint: .topLeading
            )
            .ignoresSafeArea()

            VStack {
                Button(action: {
                    self.isPopoverPresented = true
                    self.newAlarm = Alarm(date: "", ringtone: "", nameOfAlarm: "", activated: true, repeatedDays: [""])
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                .padding(.leading, 350)
                .task { await refreshAlarms() }

                if !self.isPopoverPresented {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(alarms, id: \.id) { item in
                                AlarmRowView(item: item, isOn: item.activated)
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing,20)
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                }
            }
            .popover(isPresented: $isPopoverPresented){
                
                VStack{
                    NavigationView{
                        Form{
                            Section(header: Text("Time")){
                                DatePicker("Alarm time", selection: $alarmDate, displayedComponents: .hourAndMinute)
                            }
                            Section(header: Text("Name of Alarm")){
                                    CustomTextFieldAddAlarm(text: $newAlarm.nameOfAlarm, placeholder: Text("Weekdays"))
                            }
                            //Section(header: Text("Repeated days")){
                            //CustomTextFieldAddAlarm(text: $newAlarm.[repeatedDays], placeholder: Text("Monday, Tuesday..."))
                            //}
                            Section(header: Text("Ringtone")){
                                CustomTextFieldAddAlarm(text: $newAlarm.ringtone, placeholder: Text("Beny Jr"))
                            }

                        }.navigationTitle("Add Alarm")
                        .toolbar {
                            //Cancel Button
                            ToolbarItem(placement: .navigationBarLeading){
                                Button(action: {
                                    self.isPopoverPresented = false
                                }, label:{
                                    Text("Cancel")
                                        .foregroundColor(.black)
                                })
                            }
                            //Save Button
                            ToolbarItem(placement: .navigationBarTrailing){
                                Button(action: {
                                    let date = alarmDate.formatted(date: .omitted, time: .shortened)
                                    self.newAlarm.date = date
                                    self.newAlarm = newAlarm
                                    AlarmActions().saveAlarm(alarm: newAlarm)
                                    self.isPopoverPresented = false
                                    Task{
                                        userNotifications.pushNotification(arrayOfAlarms: alarms)
                                        await refreshAlarms()
                                        
                                    }
                                }, label:{
                                    Text("Save")
                                        .foregroundColor(.black)
                                })
                            }
                            //Spotify
                        }
                    }
                }
            }
        }
    }
    
    func refreshAlarms() async {
        do {
            alarms = try await AlarmActions().loadAlarms()
        } catch {
            print("Error refreshing alarms: \(error.localizedDescription)")
        }
    }
}

struct AlarmRowView: View {
    let item: Alarm
    @State var isOn: Bool
    
    init(item: Alarm, isOn: Bool) {
        self.item = item
        _isOn = State(initialValue: item.activated)
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.date)
                    .font(.system(size: 30, weight: .semibold))
                Text(item.nameOfAlarm)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Toggle("", isOn: $isOn )
                .onChange(of: isOn){ newValue in
                    Task{
                        do{
                            var arrayOfAlarms = try await AlarmActions().loadAlarms()
                            if let alarm = arrayOfAlarms.firstIndex(where: {$0.id == item.id}){
                                arrayOfAlarms[alarm].activated = newValue
                                AlarmActions().updateArrayOfAlarms(array: arrayOfAlarms)
                            }
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct AlarmPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmPopoverView()
    }
}



func fetchData2() -> [Event] {
        var events: [Event] = []
        let scheduleStartDate = widgetUserDefaults.object(forKey: "ScheduleStartDate")
        
        let differance: Int = (Calendar.current.dateComponents([.day], from: scheduleStartDate as! Date, to: Date()).day ?? 0)
        let weekIndex = differance / 7
        var dayIndex = 0
        
        if weekIndex == 0 {
            dayIndex += differance + 1
        } else {
            dayIndex += differance - (weekIndex * 7)
        }
        
        
        let container = CKContainer(identifier: "CloudKitContainerID")
        let database = container.privateCloudDatabase
        let zoneID = CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone", ownerName: CKCurrentUserDefaultName)
        let query = CKQuery(recordType: "CD_Event", predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "CD_dayNumber == %i", Int64(dayIndex)),
            NSPredicate(format: "CD_weekNumber == %i", Int64(weekIndex))
        ]))
        
        
        database.perform(query, inZoneWith: zoneID) { (records, error) in
            if let error = error {
                print("Error fetching records: \(error)")
                return
            }
            
            guard let records = records else { return }
            for record in records {
                let newEvent = Event()
                newEvent.title = record.value(forKey: "CD_title") as? String
                newEvent.desc = record.value(forKey: "CD_desc") as? String
                newEvent.startTime = record.value(forKey: "CD_startTime") as? Date
                newEvent.endTime = record.value(forKey: "CD_endTime") as? Date
                newEvent.backgroundColor = record.value(forKey: "CD_backgroundColor") as! UIColor
                newEvent.weekNumber = record.value(forKey: "CD_weekNumber") as! Int64
                newEvent.dayNumber = record.value(forKey: "CD_dayNumber") as! Int64
                newEvent.textColor = record.value(forKey: "CD_textColor") as! UIColor
                events.append(newEvent)
            }
        }
        
        return events
    }

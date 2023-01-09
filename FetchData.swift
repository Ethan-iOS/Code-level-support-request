 func fetchData() -> [Event] {
            let context = CoreDataManager.shared.container.viewContext
            let scheduleStartDate = widgetUserDefaults.object(forKey: "ScheduleStartDate")
    
            let differance: Int = (Calendar.current.dateComponents([.day], from: scheduleStartDate as! Date, to: Date()).day ?? 0)
            let weekIndex = differance / 7
            var dayIndex = 0
    
            if weekIndex == 0 {
                dayIndex += differance + 1
            } else {
                dayIndex += differance - (weekIndex * 7)
            }
    
            let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
            let predicate1 = NSPredicate(format: "dayNumber == %i", dayIndex)
            let predicate2 = NSPredicate(format: "weekNumber == %i", weekIndex)
    
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            fetchRequest.predicate = predicate
    
            do {
                return try context.fetch(fetchRequest)
            } catch {
                print("Error fetching data: \(error)")
                return []
            }
        }


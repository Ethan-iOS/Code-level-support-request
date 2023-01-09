struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> TodayEntry {
        TodayEntry(date: Date(), events: fetchData())
    }
    
    // MARK: - Widget Now
    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> ()) {
        let entry = TodayEntry(date: Date(), events: fetchData())
        completion(entry)
    }
    
    
    // MARK: - Update widget at midnight every day
    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayEntry>) -> ()) {
        let today = Date.todayMidnight
        let tomorrow = Date.tomorrowMidnight
        let timeline = Timeline(entries: [Entry(date: today, events: fetchData())], policy: .after(tomorrow))
        completion(timeline)
    }
}

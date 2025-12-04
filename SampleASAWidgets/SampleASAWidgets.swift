//
//  SampleASAWidgets.swift
//  SampleASAWidgets
//
//  Created by ephrim.daniel on 04/12/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct SampleASAWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack (alignment: .leading){
            HStack (spacing: 1){
                Text("Saved by You")
                    .font(.footnote)
                    .fontWeight(.bold)
                Image(systemName: "chevron.forward")
                    .font(.footnote)
                    .fontWeight(.bold)
                Spacer()
            }
            Image("airtag")
                .resizable()
                .scaleEffect(1.8)
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(alignment: .center)
                .clipped()
                //.background(Color(.red))
            Text("AirTag")
                .font(.headline)
                .fontWeight(.bold)
            Text("continue to shop")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(Color(.secondaryLabel))
        }.padding(8)
    }
}

struct SampleASAWidgets: Widget {
    let kind: String = "SampleASAWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SampleASAWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SampleASAWidgetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    SampleASAWidgets()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

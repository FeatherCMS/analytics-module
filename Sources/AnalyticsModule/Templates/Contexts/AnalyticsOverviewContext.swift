//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

struct AnalyticsOverviewContext {
    
    struct Metrics {

        struct Group {
            let name: String
            let count: Int
            let percent: String
        }

        let icon: String
        let name: String
        let total: Int
        let groups: [Group]
    }

    let totalPageViews: Int
    let metrics: [Metrics]
}

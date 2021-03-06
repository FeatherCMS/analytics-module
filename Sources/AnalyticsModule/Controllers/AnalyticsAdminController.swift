//
//  AnalyticsAdminController.swift
//  AnalyticsModule
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

import Fluent
import FeatherCore
#if canImport(SQLKit)
import SQLKit
#endif

struct AnalyticsAdminController {

    struct GroupCount: Decodable {
        let name: String?
        let count: Int
    }
    
    struct MetricsGroup: TemplateDataRepresentable {
        let icon: String
        let name: String
        let groups: [GroupCount]
        
        var total: Int { groups.reduce(0, { $0 + $1.count }) }
        
        var templateData: TemplateData {
            .dictionary([
                "icon": icon,
                "name": name ,
                "groups": groups.sorted(by: { $0.count > $1.count })
                    .map { group in TemplateData.dictionary([
                        "name": group.name ?? "unknown",
                        "count": group.count,
                        "percent": String(format: "%.0f", Double(group.count) / Double(total) * 100),
                    ])},
                "total": total
            ])
        }
    }

    
    /// This won't work with the MongoDB driver yet, see https://github.com/vapor/fluent-kit/issues/206
    func count(req: Request, icon: String, name: String, groupBy group: String) -> EventLoopFuture<MetricsGroup?>{
        #if canImport(SQLKit)
        guard let db = req.db as? SQLDatabase else {
            return req.eventLoop.future(nil)
        }
        let sql = "SELECT count(id) AS `count`, `\(group)` AS name FROM analytics_logs GROUP BY `\(group)` ORDER BY count(id) DESC LIMIT 10"
        return db.raw(SQLQueryString(sql)).all(decoding: GroupCount.self).map { MetricsGroup(icon: icon, name: name, groups: $0) }
        #else
        return req.eventLoop.future(MetricsGroup(icon: icon, name: name, groups: []))
        #endif
    }
    

    func overviewView(req: Request) throws -> EventLoopFuture<View> {
        req.eventLoop.flatten([
            count(req: req, icon: "compass", name: "Browsers", groupBy: "browser_name"),
            count(req: req, icon: "monitor",  name: "Operating systems", groupBy: "os_name"),
            count(req: req, icon: "message-square",  name: "Languages", groupBy: "language"),
            count(req: req, icon: "anchor",  name: "Pages", groupBy: "path"),
        ])
        .flatMap { metrics in
            let totalPageViews = AnalyticsLogModel.query(on: req.db).count()
            return totalPageViews.flatMap { totalPageViews in
                return req.tau.render(template: "Analytics/Overview", context: [
                    "totalPageViews": .int(totalPageViews),
                    "metrics": .array(metrics.compactMap { $0?.templateData }),
                ])
            }
        }
    }
}

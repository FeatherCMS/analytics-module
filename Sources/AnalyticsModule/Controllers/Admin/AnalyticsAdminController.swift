//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import FeatherCore
import Vapor
import SQLKit
import FeatherIcons

struct AnalyticsAdminController {

    struct GroupCount: Decodable {
        let name: String?
        let count: Int
        
        var finalName: String {
            name ?? "Unknown"
        }
    }

    struct MetricsGroup {
        let icon: Svg
        let name: String
        let groups: [GroupCount]
        var total: Int { groups.reduce(0, { $0 + $1.count }) }
        
    }

    /// This won't work with the MongoDB driver yet, see https://github.com/vapor/fluent-kit/issues/206
    func count(_ req: Request, icon: Svg, name: String, groupBy group: String) async throws -> MetricsGroup? {
        guard let db = req.db as? SQLDatabase else {
            return nil
        }
        let sql = """
            SELECT
                count(id) AS `count`,
                `\(group)` AS name
            FROM analytics_logs
            GROUP BY `\(group)`
        
            ORDER BY count(id) DESC
            LIMIT 10
        """
        // WHERE name IS NOT NULL
        // print(try await db.raw(SQLQueryString(sql)).all())
        let values = try await db.raw(SQLQueryString(sql)).all(decoding: GroupCount.self).get()
        return MetricsGroup(icon: icon, name: name, groups: values)
    }

    func overviewView(_ req: Request) async throws -> Response {
        let totalPageViews = try await AnalyticsLogModel.query(on: req.db).count()
        let browser = try await count(req, icon: .compass, name: "Browsers", groupBy: "browser_name")
        let os = try await count(req, icon: .monitor,  name: "Operating systems", groupBy: "os_name")
        let lang = try await count(req, icon: .messageSquare,  name: "Languages", groupBy: "language")
        let path = try await count(req, icon: .anchor,  name: "Pages", groupBy: "path")

        let m = [browser, os, lang, path].compactMap { $0 }.map { value -> AnalyticsOverviewContext.Metrics in
            let groups = value.groups.map { g -> AnalyticsOverviewContext.Metrics.Group in
                .init(name: g.finalName,
                      count: g.count,
                      percent: String(format: "%.0f", Double(g.count) / Double(value.total) * 100))
            }
            return .init(icon: value.icon,
                         name: value.name,
                         total: value.total,
                         groups: groups)
        }
        let ctx = AnalyticsOverviewContext(totalPageViews: totalPageViews, metrics: m)
        return req.templates.renderHtml(AnalyticsOverviewTemplate(ctx))
    }
}

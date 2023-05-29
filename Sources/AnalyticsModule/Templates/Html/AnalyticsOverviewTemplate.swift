//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import FeatherCore
import Vapor
import SwiftHtml
import SwiftSvg
import FeatherIcons

final class AnalyticsOverviewTemplate: AbstractTemplate<AnalyticsOverviewContext> {

    override func render(_ req: Request) -> Tag {
//    breadcrumbs: [LinkContext(label: "Analytics", dropLast: 1)])
        req.templateEngine.system.index(.init(title: "Analytics")) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: "Analytics", excerpt: "Overview")).render(req)

                    Div {
                        Div {
                            Span {
                                Svg.eye
                            }
                            H2("\(context.totalPageViews) page views")
                            P("Total number of unique page views")
                                .class("note")
                        }
                        .class("content")
                    }
                    .class("card")
                    
                    for metric in context.metrics {
                        Div {
                            Div {
                                Span {
                                    metric.icon
                                }
                                H2(metric.name)
                                
                                for group in metric.groups {
                                    Span {
                                        Span("")
                                    }
                                    .class("bar-chart")
                                    .style("width: \(group.percent)%")
                                    
                                    Div {
                                        Div {
                                            Text("\(group.count) &middot; \(group.name)")
                                        }
                                        Div {
                                            Text("\(group.percent)%")
                                        }
                                        .class("right")
                                    }
                                    .class("grid-2")
                                }
                                
                                P("\(metric.total) &middot; total")
                                    .class(["note", "center"])
                            }
                            .class("content")
                        }
                        .class("card")
                    }
                }
            }
            .id("analytics-overview")
        }
        .render(req)
    }
}


  
                    
                

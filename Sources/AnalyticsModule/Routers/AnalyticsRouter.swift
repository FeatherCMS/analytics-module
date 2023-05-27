//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import FeatherCore
import Vapor
import AnalyticsObjects

struct AnalyticsRouter: FeatherRouter {
 
    let adminController = AnalyticsAdminController()
    
    let logAdminController = AnalyticsLogAdminController()
    let logApiController = AnalyticsLogApiController()

    func adminRoutesHook(args: HookArguments) {
    
        logAdminController.setUpListRoutes(args.routes)
        logAdminController.setUpDetailRoutes(args.routes)

        args.routes.grouped(Analytics.pathKey.pathComponent).get("overview", use: adminController.overviewView)
        
        args.routes.get(Analytics.pathKey.pathComponent) { req -> Response in
            let template = SystemAdminModulePageTemplate(.init(title: "Analytics",
                                                               tag: AnalyticsAdminWidgetTemplate().render(req)))
            return req.templates.renderHtml(template)
        }
    }
    
    func apiRoutesHook(args: HookArguments) {
        logApiController.setUpListRoutes(args.routes)
        logApiController.setUpDetailRoutes(args.routes)
    }
}


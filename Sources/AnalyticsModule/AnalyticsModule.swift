//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import FeatherCore
import FeatherObjects
import Vapor
import AnalyticsObjects

public extension HookName {
    //    static let permission: HookName = "permission"
}

struct AnalyticsModule: FeatherModule {
    
    static var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    let router = AnalyticsRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(AnalyticsMigrations.v1())

        app.hooks.register(.installPermissions, use: installUserPermissionsHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.adminCss, use: adminCssHook, priority: 42)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook, priority: 300)
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
    }
    
    func adminCssHook(args: HookArguments) -> [String] {
        [
            "/css/analytics/admin.css"
        ]
    }
    
    func adminWidgetsHook(args: HookArguments) -> [TemplateRepresentable] {
        if args.req.checkPermission(Analytics.permission(for: .detail)) {
            return [
                AnalyticsAdminWidgetTemplate()
            ]
        }
        return []
    }

    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            AnalyticsLogMiddleware(),
        ]
    }
    
    func installUserPermissionsHook(args: HookArguments) -> [FeatherPermission.Create] {
        var permissions = Analytics.availablePermissions()
        permissions += Analytics.Log.availablePermissions()
        return permissions.map { .init($0) } 
    }
}

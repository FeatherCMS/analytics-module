//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import FeatherCore
import Vapor
import AnalyticsObjects

struct AnalyticsLogAdminController: AdminListController, AdminDetailController {

    typealias ApiModel = Analytics.Log
    typealias DatabaseModel = AnalyticsLogModel
    
    func listColumns() -> [ColumnContext] {
        [
            .init("path"),
            .init("date"),
            .init("response_code"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.path, link: LinkContext(label: model.path, permission: Analytics.Log.permission(for: .detail).key)),
            .init(Feather.dateFormatter().string(from: model.date)),
            .init(model.responseCode),
        ]
    }
    
    func detailFields(for model: AnalyticsLogModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
            .init("path", model.path),
            .init("date", Feather.dateFormatter().string(from: model.date)),
            .init("session", model.session ?? ""),
            .init("method", model.method),
            .init("headers", model.headers.debugDescription),
            .init("ip", model.ip ?? ""),
            .init("origin", model.origin ?? ""),
            .init("referer", model.referer ?? ""),
            .init("language", model.language ?? ""),
            .init("region", model.region ?? ""),
            .init("os_name", model.osName ?? ""),
            .init("os_version", model.osVersion ?? ""),
            .init("browser_name", model.browserName ?? ""),
            .init("browser_version", model.browserVersion ?? ""),
            .init("engine_name", model.engineName ?? ""),
            .init("engine_version", model.engineVersion ?? ""),
            .init("device_vendor", model.deviceVendor ?? ""),
            .init("device_type", model.deviceType ?? ""),
            .init("device_model", model.deviceModel ?? ""),
            .init("cpu", model.cpu ?? ""),
            .init("response_code", model.responseCode),
        ]
    }
}

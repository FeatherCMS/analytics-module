//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

extension Analytics.Log.List: Content {}
extension Analytics.Log.Detail: Content {}

struct AnalyticsLogApiController: ApiListController, ApiDetailController {
    typealias ApiModel = Analytics.Log
    typealias DatabaseModel = AnalyticsLogModel
    
    func listOutput(_ req: Request, _ model: DatabaseModel) async throws -> Analytics.Log.List {
        .init(id: model.uuid)
    }

    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Analytics.Log.Detail {
        .init(id: model.uuid)
    }
}


//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import FeatherCore
import Vapor
import UAParserSwift
import ALanguageParser

struct AnalyticsLogMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        /// @NOTE: frontend middlewares are enabled for install paths as well, so we have to skip those...
        guard !req.url.path.hasPrefix("/install/") else {
            return try await next.respond(to: req)
        }
        guard !req.url.path.hasPrefix("/admin/") else {
            return try await next.respond(to: req)
        }
        let response = try await next.respond(to: req)
        
        let referer = req.headers.first(name: "referer")
        let origin = req.headers.first(name: "origin")
        let ip = req.headers.first(name: "X-Forwarded-For")
        let userAgent = req.headers.first(name: "user-agent") ?? ""
        let acceptLanguage = req.headers.first(name: "accept-language") ?? ""
        let ua = UAParser(agent: userAgent)
        let al = ALanguageParser.parse(acceptLanguage).first

        var headers: [String: String] = [:]
        for header in req.headers {
            headers[header.name] = header.value
        }
        /// @NOTE: we should get the IP as well
        let log = AnalyticsLogModel(session: req.session.id?.string,
                                    method: req.method.rawValue,
                                    url: req.url.string,
                                    headers: headers,
                                    ip: ip,
                                    path: req.url.path,
                                    referer: referer,
                                    origin: origin,
                                    language: al?.code,
                                    region: al?.region,
                                    osName: ua.os?.name,
                                    osVersion: ua.os?.version,
                                    browserName: ua.browser?.name,
                                    browserVersion: ua.browser?.version,
                                    engineName: ua.engine?.name,
                                    engineVersion: ua.engine?.version,
                                    deviceVendor: ua.device?.vendor,
                                    deviceType: ua.device?.type,
                                    deviceModel: ua.device?.model,
                                    cpu: ua.cpu?.identifier,
                                    responseCode: String(response.status.code))
        try await log.create(on: req.db)
        return response
    }
}

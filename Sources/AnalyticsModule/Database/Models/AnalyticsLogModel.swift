//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import FeatherCore
import Vapor
import Fluent

final class AnalyticsLogModel: FeatherDatabaseModel {
    typealias Module = AnalyticsModule

    struct FieldKeys {
        struct v1 {
            static var date: FieldKey { "date" }
            static var session: FieldKey { "session" }
            static var method: FieldKey { "method" }
            static var url: FieldKey { "url" }
            static var headers: FieldKey { "headers" }
            static var ip: FieldKey { "ip" }
            static var path: FieldKey { "path" }
            static var referer: FieldKey { "referer" }
            static var origin: FieldKey { "origin" }
            static var language: FieldKey { "language" }
            static var region: FieldKey { "region" }
            static var osName: FieldKey { "os_name" }
            static var osVersion: FieldKey { "os_version" }
            static var browserName: FieldKey { "browser_name" }
            static var browserVersion: FieldKey { "browser_version" }
            static var engineName: FieldKey { "engine_name" }
            static var engineVersion: FieldKey { "engine_version" }
            static var deviceVendor: FieldKey { "device_vendor" }
            static var deviceType: FieldKey { "device_type" }
            static var deviceModel: FieldKey { "device_model" }
            static var cpu: FieldKey { "cpu" }
            static var responseCode: FieldKey { "response_code" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.date) var date: Date
    @Field(key: FieldKeys.v1.session) var session: String?
    @Field(key: FieldKeys.v1.method) var method: String
    @Field(key: FieldKeys.v1.url) var url: String
    @Field(key: FieldKeys.v1.headers) var headers: [String: String]
    @Field(key: FieldKeys.v1.ip) var ip: String?
    @Field(key: FieldKeys.v1.path) var path: String
    @Field(key: FieldKeys.v1.referer) var referer: String?
    @Field(key: FieldKeys.v1.origin) var origin: String?
    @Field(key: FieldKeys.v1.language) var language: String?
    @Field(key: FieldKeys.v1.region) var region: String?
    @Field(key: FieldKeys.v1.osName) var osName: String?
    @Field(key: FieldKeys.v1.osVersion) var osVersion: String?
    @Field(key: FieldKeys.v1.browserName) var browserName: String?
    @Field(key: FieldKeys.v1.browserVersion) var browserVersion: String?
    @Field(key: FieldKeys.v1.engineName) var engineName: String?
    @Field(key: FieldKeys.v1.engineVersion) var engineVersion: String?
    @Field(key: FieldKeys.v1.deviceVendor) var deviceVendor: String?
    @Field(key: FieldKeys.v1.deviceType) var deviceType: String?
    @Field(key: FieldKeys.v1.deviceModel) var deviceModel: String?
    @Field(key: FieldKeys.v1.cpu) var cpu: String?
    @Field(key: FieldKeys.v1.responseCode) var responseCode: String

    init() { }

    init(id: UUID? = nil,
         date: Date = Date(),
         session: String?,
         method: String,
         url: String,
         headers: [String:String],
         ip: String? = nil,
         path: String,
         referer: String? = nil,
         origin: String? = nil,
         language: String? = nil,
         region: String? = nil,
         osName: String? = nil,
         osVersion: String? = nil,
         browserName: String? = nil,
         browserVersion: String? = nil,
         engineName: String? = nil,
         engineVersion: String? = nil,
         deviceVendor: String? = nil,
         deviceType: String? = nil,
         deviceModel: String? = nil,
         cpu: String? = nil,
         responseCode: String)
    {
        self.id = id
        self.date = date
        self.session = session
        self.method = method
        self.url = url
        self.headers = headers
        self.ip = ip
        self.path = path
        self.referer = referer
        self.origin = origin
        self.language = language
        self.region = region
        self.osName = osName
        self.osVersion = osVersion
        self.browserName = browserName
        self.browserVersion = browserVersion
        self.engineName = engineName
        self.engineVersion = engineVersion
        self.deviceVendor = deviceVendor
        self.deviceType = deviceType
        self.deviceModel = deviceModel
        self.cpu = cpu
        self.responseCode = responseCode
    }
}

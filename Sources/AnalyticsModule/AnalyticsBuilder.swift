//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 27..
//

import FeatherCore

@_cdecl("createAnalyticsModule")
public func createAnalyticsModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(AnalyticsBuilder()).toOpaque()
}

public final class AnalyticsBuilder: FeatherModuleBuilder {

    public override func build() -> FeatherModule {
        AnalyticsModule()
    }
}

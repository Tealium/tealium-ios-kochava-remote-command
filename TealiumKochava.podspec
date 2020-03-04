Pod::Spec.new do |s|

    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.name         = "TealiumKochava"
    s.module_name  = "TealiumKochava"
    s.version      = "0.0.1"
    s.summary      = "Tealium Swift and Kochava integration"
    s.description  = <<-DESC
    Tealium's integration with Kochava for iOS.
    DESC
    s.homepage     = "https://github.com/Tealium/tealium-ios-kochava-remote-command"

    # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.license      = { :type => "Commercial", :file => "LICENSE.txt" }
    
    # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.authors            = { "Tealium Inc." => "tealium@tealium.com",
        "christinasund"   => "christina.sund@tealium.com" }
    s.social_media_url   = "https://twitter.com/tealium"

    # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.swift_version = "5.0"
    s.platform     = :ios, "10.0"
    s.ios.deployment_target = "10.0"    

    # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.source       = { :git => "https://github.com/Tealium/tealium-ios-kochava-remote-command.git", :tag => "#{s.version}" }

    # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.source_files      = "Sources/*.{swift}", "Sources/TealiumKochava.h", "Sources/libKochavaTrackeriOS/*.{h}", "Sources/libKochavaCoreiOS/*.{h}"
    s.vendored_libraries = 'Sources/libKochavaCoreiOS/libKochavaCoreiOS.a', 'Sources/libKochavaTrackeriOS/libKochavaTrackeriOS.a' 

    # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.dependency 'tealium-swift/Core'
    s.ios.dependency 'tealium-swift/TealiumRemoteCommands'
    s.ios.dependency 'tealium-swift/TealiumDelegate'
    s.ios.dependency 'tealium-swift/TealiumTagManagement'
    s.ios.dependency 'tealium-swift/TealiumVolatileData'

end
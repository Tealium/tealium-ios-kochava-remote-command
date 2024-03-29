Pod::Spec.new do |s|

    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.name         = "TealiumKochava"
    s.module_name  = "TealiumKochava"
    s.version      = "1.0.0"
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
    s.source_files   = "Sources/*.swift"

    # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.dependency "tealium-swift/Core", "~> 2.1"
    s.ios.dependency "tealium-swift/RemoteCommands", "~> 2.1"
    s.ios.dependency "tealium-swift/TagManagement", "~> 2.1"
    s.vendored_frameworks = "Frameworks/KochavaTracker.xcframework", "Frameworks/KochavaCore.xcframework"

end

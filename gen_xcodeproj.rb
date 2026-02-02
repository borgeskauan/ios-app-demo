#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "xcodeproj"

APP_NAME = ENV.fetch("APP_NAME", "MyApp")
BUNDLE_ID = ENV.fetch("BUNDLE_ID", "com.example.#{APP_NAME.downcase}")
IOS_DEPLOYMENT = ENV.fetch("IOS_DEPLOYMENT", "15.0")

root = Dir.pwd
proj_path = File.join(root, "#{APP_NAME}.xcodeproj")

# Clean re-run support
FileUtils.rm_rf(proj_path)

# Create "Xcode-native" source layout:
#   <APP_NAME>/<APP_NAME>App.swift
app_dir = File.join(root, APP_NAME)
FileUtils.mkdir_p(app_dir)

app_swift = File.join(app_dir, "#{APP_NAME}App.swift")
info_plist = File.join(root, "Info.plist")

unless File.exist?(app_swift)
  File.write(app_swift, <<~SWIFT)
    import SwiftUI

    @main
    struct #{APP_NAME}App: App {
      var body: some Scene {
        WindowGroup {
          Text("Hello from #{APP_NAME}")
            .padding()
        }
      }
    }
  SWIFT
end

unless File.exist?(info_plist)
  File.write(info_plist, <<~PLIST)
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleDevelopmentRegion</key>
      <string>$(DEVELOPMENT_LANGUAGE)</string>
      <key>CFBundleExecutable</key>
      <string>$(EXECUTABLE_NAME)</string>
      <key>CFBundleIdentifier</key>
      <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
      <key>CFBundleInfoDictionaryVersion</key>
      <string>6.0</string>
      <key>CFBundleName</key>
      <string>$(PRODUCT_NAME)</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>CFBundleShortVersionString</key>
      <string>1.0</string>
      <key>CFBundleVersion</key>
      <string>1</string>
      <key>UILaunchScreen</key>
      <dict/>
      <key>UISupportedInterfaceOrientations</key>
      <array>
        <string>UIInterfaceOrientationPortrait</string>
      </array>
    </dict>
    </plist>
  PLIST
end

# Create the project
project = Xcodeproj::Project.new(proj_path)

# Groups / file refs
main_group = project.main_group

# Group named APP_NAME pointing to the APP_NAME folder
app_group = main_group.new_group(APP_NAME, APP_NAME)

# IMPORTANT: since app_group already points at ./APP_NAME,
# the file path inside it should be just the filename.
swift_ref = app_group.new_file("#{APP_NAME}App.swift")

# Optionally reference Info.plist in the project navigator (not required for building)
# This avoids duplicates if the script is adjusted not to rm_rf the xcodeproj.
main_group.new_file("Info.plist")

# Target: iOS application
target = project.new_target(:application, APP_NAME, :ios, IOS_DEPLOYMENT)

# Build settings (minimal but useful)
target.build_configurations.each do |cfg|
  cfg.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = BUNDLE_ID
  cfg.build_settings["INFOPLIST_FILE"] = "Info.plist"
  cfg.build_settings["SWIFT_VERSION"] = "5.0"
  cfg.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = IOS_DEPLOYMENT
  cfg.build_settings["TARGETED_DEVICE_FAMILY"] = "1,2" # iPhone + iPad
  cfg.build_settings["GENERATE_INFOPLIST_FILE"] = "NO"
end

# Add sources to build phase
target.add_file_references([swift_ref])

project.save

puts "Generated: #{APP_NAME}.xcodeproj"
puts "Source:    #{APP_NAME}/#{APP_NAME}App.swift"
puts "Plist:     Info.plist"
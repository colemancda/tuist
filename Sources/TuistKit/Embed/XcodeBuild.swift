// swiftlint:disable line_length
// Reference: https://developer.apple.com/legacy/library/documentation/DeveloperTools/Reference/XcodeBuildSettingRef/1-Build_Setting_Reference/build_setting_ref.html#//apple_ref/doc/uid/TP40003931-CH3-SW105
// swiftlint:enable line_length

import Basic
import Foundation

class XcodeBuild {
    public enum Action: String {
        case archive
        case install
        case build
        case clean
        case installhdrs
        case installsrc
    }

    class Environment {
        public let configuration: String
        public let configurationBuildDir: String
        public let frameworksFolderPath: String
        public let builtProductsDir: String
        public let targetBuildDir: String
        public let dwardDsymFolderPath: String
        public let expandedCodeSignIdentity: String
        public let codeSignRequired: String
        public let codeSigningAllowed: String
        public let expandedCodeSignIdentityName: String
        public let otherCodeSignFlags: String
        public let validArchs: [String]
        public let srcRoot: String
        public let action: Action

        public init(configuration: String,
                    configurationBuildDir: String,
                    frameworksFolderPath: String,
                    builtProductsDir: String,
                    targetBuildDir: String,
                    dwardDsymFolderPath: String,
                    expandedCodeSignIdentity: String,
                    codeSignRequired: String,
                    codeSigningAllowed: String,
                    expandedCodeSignIdentityName: String,
                    otherCodeSignFlags: String,
                    validArchs: [String],
                    srcRoot: String,
                    action: Action) {
            self.configuration = configuration
            self.configurationBuildDir = configurationBuildDir
            self.frameworksFolderPath = frameworksFolderPath
            self.builtProductsDir = builtProductsDir
            self.targetBuildDir = targetBuildDir
            self.dwardDsymFolderPath = dwardDsymFolderPath
            self.expandedCodeSignIdentity = expandedCodeSignIdentity
            self.codeSignRequired = codeSignRequired
            self.codeSigningAllowed = codeSigningAllowed
            self.expandedCodeSignIdentityName = expandedCodeSignIdentityName
            self.otherCodeSignFlags = otherCodeSignFlags
            self.validArchs = validArchs
            self.srcRoot = srcRoot
            self.action = action
        }

        public init?(environment: [String: String] = ProcessInfo.processInfo.environment) {
            guard let configuration = environment["CONFIGURATION"] else { return nil }
            guard let configurationBuildDir = environment["CONFIGURATION_BUILD_DIR"] else { return nil }
            guard let frameworksFolderPath = environment["FRAMEWORKS_FOLDER_PATH"] else { return nil }
            guard let builtProductsDir = environment["BUILT_PRODUCTS_DIR"] else { return nil }
            guard let targetBuildDir = environment["TARGET_BUILD_DIR"] else { return nil }
            guard let dwardDsymFolderPath = environment["DWARF_DSYM_FOLDER_PATH"] else { return nil }
            guard let expandedCodeSignIdentity = environment["EXPANDED_CODE_SIGN_IDENTITY"] else { return nil }
            guard let codeSignRequired = environment["CODE_SIGNING_REQUIRED"] else { return nil }
            guard let codeSigningAllowed = environment["CODE_SIGNING_ALLOWED"] else { return nil }
            guard let expandedCodeSignIdentityName = environment["EXPANDED_CODE_SIGN_IDENTITY_NAME"] else { return nil }
            guard let otherCodeSignFlags = environment["OTHER_CODE_SIGN_FLAGS"] else { return nil }
            guard let validArchs = environment["VALID_ARCHS"] else { return nil }
            guard let srcRoot = environment["SRCROOT"] else { return nil }
            guard let action = environment["ACTION"] else { return nil }
            self.configuration = configuration
            self.configurationBuildDir = configurationBuildDir
            self.frameworksFolderPath = frameworksFolderPath
            self.builtProductsDir = builtProductsDir
            self.targetBuildDir = targetBuildDir
            self.dwardDsymFolderPath = dwardDsymFolderPath
            self.expandedCodeSignIdentity = expandedCodeSignIdentity
            self.codeSignRequired = codeSignRequired
            self.codeSigningAllowed = codeSigningAllowed
            self.expandedCodeSignIdentityName = expandedCodeSignIdentityName
            self.otherCodeSignFlags = otherCodeSignFlags
            self.validArchs = validArchs.components(separatedBy: " ")
            self.srcRoot = srcRoot
            self.action = Action(rawValue: action) ?? .install
        }

        // MARK: - Public

        public func destinationPath() -> AbsolutePath {
            if action == .install {
                return AbsolutePath(builtProductsDir)
            } else {
                return AbsolutePath(targetBuildDir)
            }
        }

        private func frameworksPath() -> AbsolutePath {
            return destinationPath().appending(RelativePath(frameworksFolderPath))
        }
    }
}

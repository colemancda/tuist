import Basic
import Foundation

/// Protocol that represents an object that can handle files.
public protocol FileHandling: AnyObject {
    /// Returns the current path.
    var currentPath: AbsolutePath { get }

    /// Returns whether a given path points to an existing file.
    ///
    /// - Parameter path: path to check.
    /// - Returns: true if there's a file at the given path.
    func exists(_ path: AbsolutePath) -> Bool

    /// Copies a file from one location to another.
    ///
    /// - Parameters:
    ///   - from: the location the file is being copied from.
    ///   - to: the location the file is being copied to.
    func copy(from: AbsolutePath, to: AbsolutePath) throws

    /// Returns all the files using the glob pattern.
    ///
    /// - Parameters:
    ///   - path: base path.
    ///   - glob: glob pattern.
    /// - Returns: list of paths that have been found matching the glob pattern.
    func glob(_ path: AbsolutePath, glob: String) -> [AbsolutePath]

    /// Creates a folder at the given path.
    ///
    /// - Parameter path: path.
    func createFolder(_ path: AbsolutePath) throws

    /// Deletes the file at the given path.
    ///
    /// - Parameter path: path where the file is.
    /// - Throws: an error if the deletion fails.
    func delete(_ path: AbsolutePath) throws

    /// Returns true if the file at the given path is a folder.
    ///
    /// - Parameter path: path to the file/folder.
    /// - Returns: true if the path points to a folder.
    func isFolder(_ path: AbsolutePath) -> Bool
}

/// Default file handler implementing FileHandling.
public final class FileHandler: FileHandling {
    public init() {}

    /// Returns the current path.
    public var currentPath: AbsolutePath {
        return AbsolutePath(FileManager.default.currentDirectoryPath)
    }

    /// Returns whether a given path points to an existing file.
    ///
    /// - Parameter path: path to check.
    /// - Returns: true if there's a file at the given path.
    public func exists(_ path: AbsolutePath) -> Bool {
        return FileManager.default.fileExists(atPath: path.asString)
    }

    /// Copies a file from one location to another.
    ///
    /// - Parameters:
    ///   - from: the location the file is being copied from.
    ///   - to: the location the file is being copied to.
    public func copy(from: AbsolutePath, to: AbsolutePath) throws {
        try FileManager.default.copyItem(atPath: from.asString, toPath: to.asString)
    }

    /// Returns all the files using the glob pattern.
    ///
    /// - Parameters:
    ///   - path: base path.
    ///   - glob: glob pattern.
    /// - Returns: list of paths that have been found matching the glob pattern.
    public func glob(_ path: AbsolutePath, glob: String) -> [AbsolutePath] {
        return path.glob(glob)
    }

    /// Creates a folder at the given path.
    ///
    /// - Parameter path: path.
    public func createFolder(_ path: AbsolutePath) throws {
        try FileManager.default.createDirectory(at: path.url,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }

    /// Deletes the file at the given path.
    ///
    /// - Parameter path: path where the file is.
    /// - Throws: an error if the deletion fails.
    public func delete(_ path: AbsolutePath) throws {
        try FileManager.default.removeItem(atPath: path.asString)
    }

    /// Returns true if the file at the given path is a folder.
    ///
    /// - Parameter path: path to the file/folder.
    /// - Returns: true if the path points to a folder.
    public func isFolder(_ path: AbsolutePath) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path.asString, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}

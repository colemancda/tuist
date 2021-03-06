import Basic
import Foundation
import TuistCore
import Utility

enum EmbedCommandError: FatalError {
    case missingFrameworkPath

    var type: ErrorType {
        switch self {
        case .missingFrameworkPath:
            return .bug
        }
    }

    var description: String {
        switch self {
        case .missingFrameworkPath:
            return "The path to the framework is missing."
        }
    }
}

final class EmbedCommand: HiddenCommand {

    // MARK: - HiddenCommand

    static var command: String = "embed"

    // MARK: - Attributes

    private let embedder: FrameworkEmbedding
    private let parser: ArgumentParser
    private let fileHandler: FileHandling

    // MARK: - Init

    convenience init() {
        self.init(embedder: FrameworkEmbedder(),
                  parser: ArgumentParser(usage: "embed", overview: ""),
                  fileHandler: FileHandler())
    }

    init(embedder: FrameworkEmbedding,
         parser: ArgumentParser,
         fileHandler: FileHandling) {
        self.embedder = embedder
        self.parser = parser
        self.fileHandler = fileHandler
    }

    func run(arguments: [String]) throws {
        guard let pathString = arguments.first else {
            throw EmbedCommandError.missingFrameworkPath
        }
        let path = AbsolutePath(pathString, relativeTo: fileHandler.currentPath)
        try embedder.embed(path: path)
    }
}

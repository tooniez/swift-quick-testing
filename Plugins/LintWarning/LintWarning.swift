import Foundation
import PackagePlugin

@main
struct LintWarning: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: any Target) async throws -> [Command] {
        try makeCommand(
            executable: context.tool(named: "QuickLint"),
            files: (target as? SourceModuleTarget).flatMap(lintableFiles(target:)) ?? [],
            pluginWorkDirectory: context.pluginWorkDirectory
        )
    }

    private func lintableFiles(target: SourceModuleTarget) -> [Path] {
        target
            .sourceFiles
            .filter(isLintable(file:))
            .map { $0.path }
    }

    private func isLintable(file: PackagePlugin.File) -> Bool {
        return ["swift", "m", "mm"].contains(file.path.extension ?? "")
    }

    private func makeCommand(
        executable: PluginContext.Tool,
        files: [Path],
        pluginWorkDirectory path: Path) throws -> [Command] {
            guard files.isEmpty == false else { return [] }

            return [Command.buildCommand(
                displayName: "quicklint",
                executable: executable.path,
                arguments: ["lint"] + files.map { $0.string },
                inputFiles: files,
                outputFiles: files
            )]
        }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension LintWarning: XcodeBuildToolPlugin {
    func createBuildCommands(
            context: XcodePluginContext,
            target: XcodeTarget
        ) throws -> [Command] {
            try makeCommand(
                executable: context.tool(named: "QuickLint"),
                files: lintableFiles(target: target),
                pluginWorkDirectory: context.pluginWorkDirectory
            )
        }

    private func lintableFiles(target: XcodeTarget) -> [Path] {
        target.inputFiles
            .filter(isLintable(file:))
            .map { $0.path }
    }

}

#endif

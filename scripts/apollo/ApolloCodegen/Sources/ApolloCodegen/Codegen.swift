import Foundation
import ApolloCodegenLib

func codegen() throws {
    try ApolloCodegen.run(
        from: cwd,
        with: cliPath,
        options: ApolloCodegenOptions(
            includes: "schemas/graphql/*.graphql",
            namespace: nil,
            outputFormat: .multipleFiles(inFolderAtURL: cwd.appendingPathComponent("GraphQL")),
            customScalarFormat: .passthrough,
            urlToSchemaFile: schemaPath
        )
    )
}

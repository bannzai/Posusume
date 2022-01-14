import Foundation
import ApolloCodegenLib

func codegen() throws {
    try ApolloCodegen.run(
        from: appPath,
        with: cliPath,
        options: ApolloCodegenOptions(
            includes: "schemas/graphql/*.graphql",
            namespace: "GraphQL",
            outputFormat: .singleFile(atFileURL: appPath.appendingPathComponent("Sources/Network/GraphQL/GraphQL.swift")),
            customScalarFormat: .passthrough,
            urlToSchemaFile: schemaPath
        )
    )
}

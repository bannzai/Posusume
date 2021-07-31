import Foundation
import ApolloCodegenLib

func downloadSchema() throws {
    guard let introspectionURLString = ProcessInfo.processInfo.environment["POSUSUME_GRAPHQL_API_INTROSPECTION_URL"],
          let introspectionURL = URL(string: introspectionURLString) else {
        fatalError("Unexpected POSUSUME_GRAPHQL_API_INTROSPECTION_URL is empty or invalid URL")
    }
    print("Put schema file to \(schemaPath.absoluteString)")
    
    try ApolloSchemaDownloader.run(
        with: cliPath,
        options: .init(
            downloadMethod: .introspection(endpointURL: introspectionURL),
            outputFolderURL: schemaPath
        )
    )
}

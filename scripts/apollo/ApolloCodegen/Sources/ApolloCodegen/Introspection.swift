import Foundation
import ApolloCodegenLib

func downloadSchema() throws {
    guard let introspectionURLString = ProcessInfo.processInfo.environment["POSUSUME_GRAPHQL_API_INTROSPECTION_URL"],
          let introspectionURL = URL(string: introspectionURLString) else {
        fatalError("Unexpected POSUSUME_GRAPHQL_API_INTROSPECTION_URL is empty or invalid URL")
    }
    print("Put schema file from \(introspectionURLString) to \(schemaPath.absoluteString)")
    
    guard let adminSecret = ProcessInfo.processInfo.environment["HASURA_ADMIN_SECRET"] else {
        fatalError("downloadSchema necessary HASURA_ADMIN_SECRET")
    }

    try ApolloSchemaDownloader.run(
        with: cliPath,
        options: ApolloSchemaOptions(
            downloadMethod: .introspection(endpointURL: introspectionURL),
            headers: ["X-Hasura-Admin-Secret: \(adminSecret)"],
            outputFolderURL: schemaPath.deletingLastPathComponent(),
            downloadTimeout: 30
        )
    )
}

import Foundation

print("Launched ApolloCodegen process... 🥚")

let cwd = URL(string: FileManager.default.currentDirectoryPath)!
print("cwd: ", cwd)
let cliPath = cwd.appendingPathComponent("ApolloCodegen/ApolloCLI")
print("ApolloCodegen CLI binary path of \(cliPath.absoluteString)")
let schemaPath = cwd.appendingPathComponent("schema.json")
print("ApolloCodegen will download and use schema path of \(schemaPath.absoluteString)")

do {
    print("Begin introspection...")
    try introspection()
} catch {
    fatalError("introspection failed. details: \(error))")
}
print("End introspection")

do {
    print("Begin codegen...")
    try codegen()
} catch {
    fatalError("codegen failed. details: \(error))")
}

print("End codegen")
print("End ApolloCodegen 🐣")

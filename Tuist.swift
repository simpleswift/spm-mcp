import ProjectDescription

let tuist = Tuist(
  project: .tuist(
    compatibleXcodeVersions: .all,
    swiftVersion: "6.0",
    plugins: [],
    generationOptions: .options(),
    installOptions: .options()
  )
)

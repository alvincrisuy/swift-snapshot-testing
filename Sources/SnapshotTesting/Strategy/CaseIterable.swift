
extension Strategy where Snapshottable: CaseIterable, Format == String  {

  public static func `func`<A>(into witness: Strategy<A, Format>) -> Strategy<(Snapshottable) -> A, Format> {

    var strategy = Strategy<String, String>.lines.asyncPullback { (f: (Snapshottable) -> A) in

      Snapshottable.allCases.map { input in
        witness.snapshotToDiffable(f(input))
          .map { (input, $0) }
        }
        .sequence()
        .map { rows in
          rows.map { "\"\($0)\",\"\($1)\"" }
            .joined(separator: "\n")
      }
    }

    strategy.pathExtension = "csv"
    return strategy
  }
}

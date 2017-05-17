%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "web/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Consistency.TabsOrSpaces},
        {Credo.Check.Consistency.MultiAliasImportRequireUse, false},
        {Credo.Check.Design.AliasUsage, false},
        {Credo.Check.Refactor.PipeChainStart, false},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 100},
        {Credo.Check.Design.TagTODO, false},
        {Credo.Check.Warning.LazyLogging, false}
      ]
    }
  ]
}

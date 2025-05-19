// Gemini 2.5 Pro (Version=05-06)
let
    // 1. Generate a list of numbers from 0 to 1439 (representing total minutes in a day)
    MinuteOffsets = List.Numbers(0, 24 * 60),
    // 2. Convert the list of numbers into a table with a single column named "MinuteOffset"
    SourceTable = Table.FromList(MinuteOffsets, Splitter.SplitByNothing(), {"MinuteOffset"}, null, ExtraValues.Error),
    // 3. Add the 'time' column
    AddedTimeColumn = Table.AddColumn(SourceTable, "time", each Time.From([MinuteOffset] / (24 * 60)), type time),
    AddedHourNumColumn = Table.AddColumn(AddedTimeColumn, "hour_num", each Number.IntegerDivide([MinuteOffset], 60), Int64.Type),
    AddedMinuteNumColumn = Table.AddColumn(AddedHourNumColumn, "minute_num", each Number.Mod([MinuteOffset], 60), Int64.Type),
    RemovedOffsetColumn = Table.RemoveColumns(AddedMinuteNumColumn, {"MinuteOffset"}),
    ReorderedColumns = Table.ReorderColumns(RemovedOffsetColumn, {"time", "hour_num", "minute_num"})
in
    ReorderedColumns

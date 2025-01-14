# Calendar
#
# Date, Time, and DateTime are structs in the standard library. Constructors
# return {:ok, value} or {:error, reason}. The bang variants raise on bad input.
# A Date has no timezone. A DateTime does.
#
# Run: elixir 33_calendar/main.exs

{:ok, date} = Date.new(2026, 10, 28)
IO.puts(Date.to_iso8601(date))
IO.puts(Date.day_of_week(date))
IO.puts(Date.add(date, 2) |> Date.to_iso8601())

{:ok, time} = Time.new(9, 30, 0)
IO.puts(Time.to_iso8601(time))

# from_iso8601 also returns the offset from UTC, in seconds.
{:ok, moment, 0} = DateTime.from_iso8601("2026-10-28T12:00:00Z")
IO.puts(DateTime.to_iso8601(moment))
IO.puts(moment.time_zone)

# A bad calendar date is an error tuple, not an exception, unless you use the
# bang function.
IO.inspect(Date.new(2026, 2, 31))

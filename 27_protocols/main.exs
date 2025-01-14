# Protocols
#
# A protocol is a set of functions that different data types implement in their
# own way. Calling the protocol dispatches to the implementation for the value
# you passed. This is Elixir's mechanism for polymorphism.
#
# Run: elixir 27_protocols/main.exs

defprotocol Blank do
  def blank?(data)
end

defimpl Blank, for: BitString do
  def blank?(""), do: true
  def blank?(_string), do: false
end

defimpl Blank, for: List do
  def blank?([]), do: true
  def blank?(_list), do: false
end

defimpl Blank, for: Atom do
  def blank?(nil), do: true
  def blank?(false), do: true
  def blank?(_atom), do: false
end

IO.puts(Blank.blank?(""))
IO.puts(Blank.blank?("rune"))
IO.puts(Blank.blank?([]))
IO.puts(Blank.blank?([1]))
IO.puts(Blank.blank?(nil))
IO.puts(Blank.blank?(:ok))

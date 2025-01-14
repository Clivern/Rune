# URI
#
# URI.parse splits a URL into a struct. The fields are strings, except the port,
# which is an integer when it is written in the URL. URI.to_string builds the
# text again.
#
# Run: elixir 36_uri/main.exs

uri = URI.parse("https://example.com:443/docs/rune?q=maps#top")
IO.puts(uri.scheme)
IO.puts(uri.host)
IO.puts(uri.port)
IO.puts(uri.path)
IO.puts(uri.query)
IO.puts(uri.fragment)

# decode_query turns the query string into a map of strings.
IO.inspect(URI.decode_query(uri.query))

# A new URI can be assembled and rendered. Empty fields are omitted.
built = %URI{scheme: "https", host: "example.com", path: "/docs"}
IO.puts(URI.to_string(built))

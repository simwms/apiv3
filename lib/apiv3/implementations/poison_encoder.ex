defimpl Poison.Encoder, for: Timex.DateTime do
  def encode(datetime, options) do
    datetime
    |> Timex.DateFormat.format!("{ISO}")
    |> Poison.Encoder.BitString.encode(options)
  end
end
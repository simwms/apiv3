defimpl String.Chars, for: Timex.DateTime do
  def to_string(datetime) do
    datetime |> Timex.DateFormat.format!("{ISO}")
  end
end
defimpl Phoenix.HTML.Safe, for: Timex.DateTime do
  def to_iodata(datetime) do
    datetime |> Kernel.to_string
  end
end
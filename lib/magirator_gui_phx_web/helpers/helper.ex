defmodule MagiratorGuiPhxWeb.Helpers.Helper do

  @doc """
  Convert map string keys to :atom keys
  """
  def atomize_keys(nil), do: nil

  # Structs don't do enumerable and anyway the keys are already
  # atoms
  def atomize_keys(struct = %{__struct__: _}) do
    struct
  end

  def atomize_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
  end


  def expect_ok( {:ok, data} ) do
    data
  end

  def expect_ok( _ ) do
    :error
  end

  def caller_as_atom(caller) do
    case caller do
      "deck" ->
        :deck
      _ -> 
        :caller_error
    end
  end

  def mics_to_ms(microseconds) do
    microseconds/1000
  end

  def clock(mark, fun, args) do
    {time, result} = :timer.tc(fun, args)
    ms_time = mics_to_ms(time)
    IO.puts(mark <> ": #{ms_time} ms")
    result
  end
end
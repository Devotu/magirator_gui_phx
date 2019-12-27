defmodule MagiratorGuiPhxWeb.ImportController do
  use MagiratorGuiPhxWeb, :controller

  def new(conn, %{"error" => error}) do
    IO.inspect(error)
    render conn, "new.html", %{error: error}
  end

  def new(conn, %{"result" => result}) do
    IO.inspect(result)
    render conn, "new.html", %{result: result}
  end

  def new(conn, _params) do
    IO.inspect("new")
    render conn, "new.html"
  end

  def import(conn, %{"import" => %{"player_id" => player_id, "data" => data}} = p) do
    IO.inspect(player_id)
    IO.inspect(data)
    IO.inspect(p)
    IO.inspect(conn.assigns)

    parsed_data = Poison.decode(~s(#{data}))

    IO.inspect(parsed_data)

    case parsed_data do
      {:error, msg} ->
        display_error(conn, msg)
      _ -> 
        import_data(conn, data, player_id)
    end
  end

  def import(conn, _params) do
    redirect(conn, to: import_path(conn, :new))
  end

  defp import_data(conn, data, player_id) do
    IO.inspect("importing")
    redirect(conn, to: import_path(conn, :new, result: "imported"))
  end

  defp display_error(conn, msg) do
    IO.inspect("error #{Kernel.inspect(msg)}")
    redirect(conn, to: import_path(conn, :new, error: "invalid json"))
  end
end
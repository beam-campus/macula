defmodule SwaiWeb.IdenticonController do
  use SwaiWeb, :controller


  alias Identicon

  def show(conn, %{"input" => input}) do
    # image = Identicon.generate(input)
    send_resp(conn, 200, input)
  end

end

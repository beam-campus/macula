defmodule WebRepl do
  @moduledoc false

  alias Accounts
  alias Licenses.Service, as: Licenses
  alias Swai.Accounts

  def get_full_licenses do
    %{id: user_id} =
      Accounts.get_user_by_email("rl@discomco.pl")

    Licenses.get_all_for_user(user_id)
  end
end

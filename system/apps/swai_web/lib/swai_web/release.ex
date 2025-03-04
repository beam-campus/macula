defmodule SwaiWeb.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """

  alias Swai.Seeds

  @web_app :swai_web
  @app :swai

  def migrate do
    load_web_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end

    seed()
  end

  def seed do
    {:ok, _} = Application.ensure_all_started(@app)

    Swai.Seeds.run()
  end

  def rollback(repo, version) do
    load_web_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@web_app, :ecto_repos)
  end


  defp load_web_app do
    Application.load(@web_app)
  end
end

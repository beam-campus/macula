defmodule SwaiWeb.Layouts.App do


  @moduledoc """
  This layout is used for the main layout of the application.
  """
  alias Phoenix.LiveView.JS

  def toggle_dropdown_menu do
    JS.toggle(
      to: "#dropdown_menu",
      in: {
        "transition ease-out duration-300",
        "transform opacity-0 translate-y-[-10%]",
        "transform opacity-100 translate-y-0"
      },
      out: {
        "transition ease-in duration-300",
        "transform opacity-100 translate-y-0",
        "transform opacity-0 translate-y-[-10%]"
      }
    )
  end

  def toggle_scapes_menu do
    JS.toggle(
      to: "#scapes_menu",
      in: {
        "transition ease-out duration-300",
        "transform opacity-0 translate-y-[-10%]",
        "transform opacity-100 translate-y-0"
      },
      out: {
        "transition ease-in duration-300",
        "transform opacity-100 translate-y-0",
        "transform opacity-0 translate-y-[-10%]"
      }
    )
  end



end

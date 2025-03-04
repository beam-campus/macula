defmodule Colors do
  @moduledoc """
  Colors is the module that contains the colors for the Swai System
  """

  def reset, do: "\e[0m"
  def red_on_black, do: "\e[31;40m"
  def green_on_black, do: "\e[32;40m"
  def yellow_on_black, do: "\e[33;40m"
  def blue_on_black, do: "\e[34;40m"
  def magenta_on_black, do: "\e[35;40m"
  def cyan_on_black, do: "\e[36;40m"
  def white_on_black, do: "\e[37;40m"

  def red_on_white, do: "\e[31;47m"
  def green_on_white, do: "\e[32;47m"
  def yellow_on_white, do: "\e[33;47m"
  def blue_on_white, do: "\e[34;47m"
  def magenta_on_white, do: "\e[35;47m"
  def cyan_on_white, do: "\e[36;47m"
  def white_on_white, do: "\e[37;47m"

  def yellow_on_red, do: "\e[33;41m"
  def yellow_on_green, do: "\e[33;42m"
  def yellow_on_blue, do: "\e[33;44m"
  def yellow_on_magenta, do: "\e[33;45m"
  def yellow_on_cyan, do: "\e[33;46m"
  def yellow_on_blue_blinking, do: "\e[5;33;44m"
  def yellow_on_red_blinking, do: "\e[5;33;41m"
  def yellow_on_green_blinking, do: "\e[5;33;42m"
  def yellow_on_magenta_blinking, do: "\e[5;33;45m"
  def yellow_on_cyan_blinking, do: "\e[5;33;46m"

  def green_on_black_blinking, do: "\e[5;32;40m"
  def red_on_black_blinking, do: "\e[5;31;40m"
  def blue_on_black_blinking, do: "\e[5;34;40m"
  def magenta_on_black_blinking, do: "\e[5;35;40m"
  def cyan_on_black_blinking, do: "\e[5;36;40m"
  def white_on_black_blinking, do: "\e[5;37;40m"
  def yellow_on_black_blinking, do: "\e[5;33;40m"

  def black_on_white, do: "\e[30;47m"
  def black_on_red, do: "\e[30;41m"
  def black_on_green, do: "\e[30;42m"
  def black_on_yellow, do: "\e[30;43m"
  def black_on_blue, do: "\e[30;44m"
  def black_on_magenta, do: "\e[30;45m"
  def black_on_cyan, do: "\e[30;46m"

  def black_on_white_blinking, do: "\e[5;30;47m"
  def black_on_red_blinking, do: "\e[5;30;41m"
  def black_on_green_blinking, do: "\e[5;30;42m"
  def black_on_yellow_blinking, do: "\e[5;30;43m"
  def black_on_blue_blinking, do: "\e[5;30;44m"
  def black_on_magenta_blinking, do: "\e[5;30;45m"
  def black_on_cyan_blinking, do: "\e[5;30;46m"

  def white_on_magenta, do: "\e[37;45m"
  def white_on_cyan, do: "\e[37;46m"
  def white_on_red, do: "\e[37;41m"
  def white_on_green, do: "\e[37;42m"
  def white_on_blue, do: "\e[37;44m"

  def edge_theme(pid),
    do: "#{yellow_on_black()}#{inspect(pid)}#{reset()}"

  def scape_theme(pid),
    do: "#{yellow_on_red()}#{inspect(pid)}#{reset()}"

  def hive_theme(pid),
    do: "#{yellow_on_green()}#{inspect(pid)}#{reset()}"

  def farm_theme(pid),
    do: "#{yellow_on_black()}#{inspect(pid)}#{reset()}"

  def field_theme(pid),
    do: "#{white_on_green()}#{inspect(pid)}#{reset()}"

  def cell_theme(pid),
    do: "#{white_on_blue()}#{inspect(pid)}#{reset()}"

  def particle_theme(pid),
    do: "#{white_on_magenta()}#{inspect(pid)}#{reset()}"

  def particle_life_worker_theme(pid),
    do: "#{green_on_black()}#{inspect(pid)}#{reset()}"

  def server_theme(pid),
    do: "#{yellow_on_black()}#{inspect(pid)}#{reset()}"

  def swarm_theme(pid),
    do: "#{yellow_on_black_blinking()}#{inspect(pid)}#{reset()}"

  def arena_theme(pid),
    do: "#{white_on_blue()}#{inspect(pid)}#{reset()}"
end

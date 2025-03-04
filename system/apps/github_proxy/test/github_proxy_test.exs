defmodule GithubProxyTest do
  use ExUnit.Case
  doctest GithubProxy

  test "greets the world" do
    assert GithubProxy.hello() == :world
  end
end

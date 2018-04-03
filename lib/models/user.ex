defmodule Zendesk.User do
  @moduledoc """
  Zendesk User
  """

  def new(name: name, email: email) do
    %{name: name, email: email}
  end

  def new(email: email) do
    name = Regex.split(~r{@}, email) |> List.first
    %{name: name, email: email}
  end


  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def from_json_array(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:users)
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:user)
  end

  def to_json(user) do
    Poison.encode!(%{user: user})
  end

end

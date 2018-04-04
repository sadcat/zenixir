defmodule Zendesk.Organization do
  @moduledoc """
  Zendesk Organization
  """


  def new(name: name, external_id: external_id) do
    %{name: name, external_id: external_id}
  end

  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Map.get(:organizations)
  end

  def to_json(organization) do
    Poison.encode!(%{organization: organization})
  end

end

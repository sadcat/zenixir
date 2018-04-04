defmodule Zendesk.User do
  @moduledoc """
  Zendesk User
  """

  def new(name: name, external_id: external_id) do
    %{name: name, external_id: external_id}
  end

  def add_email(user, email: email) do
    Map.put(user, :email, email)
  end

  def add_phone(user, phone: phone) do
    Map.put(user, :phone, phone)
  end

  def add_timezone(user, time_zone: time_zone) do
    Map.put(user, :time_zone, time_zone)
  end

  def add_organization(user, organization_id: organization_id) do
    Map.put(user, :organization_id, organization_id)
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

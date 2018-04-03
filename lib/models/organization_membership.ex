defmodule Zendesk.OrganizationMembership do
  @moduledoc """
  Zendesk Organization membership
  """

  import Zendesk.CommonUtils

  def new(user_id: user_id, organization_id: organization_id) do
    %{user_id: user_id, organization_id: organization_id}
  end

  def to_json(organization_membership) do
    Poison.encode!(%{organization_membership: organization_membership})
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:organization_membership)
  end

end

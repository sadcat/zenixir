defmodule Zendesk.OrganizationMembershipApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk user organization membership
  """

  @create_organization_membership "/organization_memberships.json"

  use Zendesk.CommonApi
  alias Zendesk.OrganizationMembership

  def create_organization_membership(account, organization_membership) do
    perform_request(&parse_single_organization_membership/1, account: account, verb: :post,
    endpoint: @create_organization_membership,
    headers: headers(),
    body: OrganizationMembership.to_json(organization_membership))
  end

  defp headers do
    ["Content-Type": "application/json"]
  end

  defp parse_single_organization_membership(response) do
    Zendesk.OrganizationMembership.from_json(response)
  end
end

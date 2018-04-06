defmodule Zendesk.CommonApi do

  require Logger
  defmacro __using__(_) do
    quote do

      defp perform_request(parse_method, args) do
        import Zendesk.CommonApi
        internal_perform_request(parse_method,
        account: Keyword.get(args, :account),
        verb:  Keyword.get(args, :verb),
        endpoint: Keyword.get(args, :endpoint),
        body: Keyword.get(args, :body),
        headers: Keyword.get(args, :headers))
      end

      defp perform_upload_file(parse_method, account: account, endpoint: endpoint, file: file) do
        import Zendesk.CommonApi

        internal_upload_file(parse_method,
        account: account,
        endpoint: endpoint,
        file: file)
      end

    end
  end

  def internal_perform_request(parse_method, account: account, verb: verb, endpoint: endpoint, body: body, headers: headers) do
    full_endpoint = Zendesk.Account.full_url(account, endpoint)
    params = prepare_params(account, body, headers)
    params
    |> http_request(verb, full_endpoint)
    |> parse_response(parse_method, full_endpoint)
  end

  def internal_upload_file(parse_method, account: account, endpoint: endpoint, file: body) do

    full_endpoint = Zendesk.Account.full_url(account, endpoint)

    prepare_params(account, body, ["Content-Type": "application/binary"])
    |> http_request(:upload, full_endpoint)
    |> parse_response(parse_method, full_endpoint)
  end

  def parse_response(%HTTPoison.Response{status_code: status_code, body: body}, _parse_method, _endpoint)
  when status_code >= 400 do
    Zendesk.Error.from_json(body)
  end
  def parse_response(%HTTPoison.Response{status_code: status_code}, parse_method, _)
  when status_code == 204 do
    parse_method.(:ok)
  end
  def parse_response(response, parse_method, _) do
    parse_response(body: response.body, parse_method: parse_method)
  end
  def parse_response(body: body, parse_method: _)
  when body == " " or body == "" or is_nil(body) do
    :ok
  end
  def parse_response(body: body, parse_method: parse_method) do
    parse_method.(body)
  end

  def prepare_params(account, body, headers) do
    empty_params()
    |> add_auth(account)
    |> add_body(body)
    |> add_headers(headers)
  end

  def http_request(params, :get, url) do
    auth = List.first(params)
    case auth do
      [hackney: _] ->
        HTTPoison.get!(url, [], auth ++ set_httpoison_timedout())
      _ ->
        HTTPoison.get!(url, auth, [] ++ set_httpoison_timedout())
    end
  end
  def http_request(params, :put, url) do
    case length(params) do
      1 ->
        [auth] = params
        HTTPoison.put!(url, "", [], auth ++ set_httpoison_timedout())
      3 ->
        [auth, {:body, body}, {:headers, headers}] = params
        HTTPoison.put!(url, body, headers, auth ++ set_httpoison_timedout())
    end
  end
  def http_request(params, :post, url) do
    [auth, {:body, body}, {:headers, headers}] = params
    HTTPoison.post!(url, body, headers, auth ++ set_httpoison_timedout())
  end
  def http_request(params, :upload, url) do
    [auth, {:body, body}, {:headers, headers}] = params
    HTTPoison.post!(url, body, headers, auth ++ set_httpoison_timedout())
  end
  def http_request(params, :delete, url) do
    auth = List.first(params)
    HTTPoison.delete!(url, [], auth ++ set_httpoison_timedout())
  end

  defp empty_params do
    []
  end

  defp add_auth(params, account) do
    params ++ [Zendesk.Account.auth(account)]
  end

  defp add_body(params, nil) do
    params
  end
  defp add_body(params, body) do
    params ++ [body: body]
  end

  defp add_headers(params, nil) do
    params
  end
  defp add_headers(params, headers) do
    params ++ [headers: headers]
  end

  defp set_httpoison_timedout() do
    timeout = System.get_env("HTTPOISON_TIMEOUT")
    recv_timeout = System.get_env("HTTPOISON_RECV_TIMEOUT")

    if timeout == nil && recv_timeout == nil do
      [{:timeout, 120000}, {:recv_timeout, 60000}]
    else
      [{:timeout, String.to_integer(timeout)}, {:recv_timeout, String.to_integer(recv_timeout)}]
    end
  end
end

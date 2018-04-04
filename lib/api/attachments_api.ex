
defmodule Zendesk.AttachmentApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk attachments
  """

  @upload_file "/uploads.json?filename=%s"
  @show_attachment "/attachments/%s.json"
  @delete_attachment "/attachments/%s.json"

  use Zendesk.CommonApi


  @doc """
  Upload file

  `file_name` file name uploaded

  `file_path` the file path
  """
  def upload_file(account, file_name: file_name, file_path: path) do
    upload_file(account,
    file_name,
    File.read(path))
  end

  defp upload_file(account, file_name, {:ok, file_path}) do
    perform_upload_file(&parse_upload/1,
    account: account,
    endpoint: ExPrintf.sprintf(@upload_file, [file_name]),
    file: file_path)
  end

  defp upload_file(_, _, {_, _}) do
    raise "File not found"
  end

  @doc """
  Show an attachment

  `attachment_id` the attachment id
  """
  def show_attachment(account, attachment_id: attachment_id) do
    perform_request(&parse_attachment/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@show_attachment, [attachment_id]))
  end

  @doc """
  Delete an attachment

  `attachment_id` the attachment id
  """
  def delete_attachment(account, attachment_id: attachment_id) do
    perform_request(&parse_delete/1, account: account, verb: :delete,
    endpoint: ExPrintf.sprintf(@delete_attachment, [attachment_id]))
  end

  # Private

  defp parse_delete(response) do
    response
  end

  defp parse_upload(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Map.get(:upload)
  end

  defp parse_attachment(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Map.get(:attachment)
  end

end

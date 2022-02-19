defmodule OAuth2.Provider.Shopify.URL do
  @moduledoc """
  Shopify URL utility
  """
  @http_regex ~r/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\x{00a1}-\x{ffff}0-9]+-?)*[a-z\x{00a1}-\x{ffff}0-9]+)(?:\.(?:[a-z\x{00a1}-\x{ffff}0-9]+-?)*[a-z\x{00a1}-\x{ffff}0-9]+)*(?:\.(?:[a-z\x{00a1}-\x{ffff}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/ius

  @doc """
  Takes a string and formats it to return `{domain}.myshopify.com`.

  Returns false if it detects a URL that is not myshopify.com. But will build a URL if you
  enter just the subdomain.
  """
  def normalise_url(string) do
    string
    |> handle_myshopify_url
    |> raise_on_non_shopify_domain
    |> handle_string
  end

  @doc """
  Simple prefix https protocol.

  Checks for http:// or https://, if it doesn't find either protocol `https://` is prefixed.
  """
  def prefix_protocol(string) do
    unless String.starts_with?(string, ["http://", "https://"]) do
      "https://#{string}"
    end
  end

  @doc """
  Check string for being a valid `myshopify.com` url
  """
  def myshopify_domain?(string) do
    Fuzzyurl.matches?("*.myshopify.com", string)
  end

  @doc """
  Returns top level domain from `myshopify.com` url.
  """
  def extract_shop_domain(string) do
    parsed_url =
      Fuzzyurl.from_string(string).hostname
      |> Domainatrex.parse()

    case parsed_url do
      {:ok, %{domain: "myshopify", subdomain: subdomain, tld: "com"}} ->
        subdomain

      _ ->
        false
    end
  end

  # Private
  defp raise_on_non_shopify_domain(string) do
    # should allow both "example.myshopify.com" and "example"
    # to pass through. But raise for any other domain.
    case String.match?(string, @http_regex) do
      true -> raise ArgumentError, message: "invalid argument"
      false -> string
    end
  end

  defp handle_myshopify_url(string) do
    if myshopify_domain?(string) do
      extract_shop_domain(string)
    else
      string
    end
  end

  defp handle_string(string) do
    "#{string}.myshopify.com"
  end
end

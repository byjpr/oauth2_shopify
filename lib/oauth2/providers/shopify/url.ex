defmodule OAuth2.Provider.Shopify.URL do
  @moduledoc """
  Shopify URL utility
  """

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
end

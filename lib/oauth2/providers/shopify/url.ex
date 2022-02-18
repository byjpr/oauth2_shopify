defmodule OAuth2.Provider.Shopify.URL do
  @moduledoc """
  Shopify URL utility
  """

  @doc """
  Takes a string and formats it to return `{domain}.myshopify.com`
  """
  def normalise(string) do
    if(myshopify_domain?(string)) do
      subdomain = extract_shop_domain(string)
      {:ok, "#{subdomain}.myshopify.com"}
    else
      {:error, string}
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
end

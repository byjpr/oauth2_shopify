defmodule OAuth2.Provider.ShopifyTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import OAuth2.TestHelpers

  alias OAuth2.Client
  alias OAuth2.AccessToken
  alias OAuth2.Provider.Shopify

  doctest OAuth2.Provider.Shopify

  setup do
    server = Bypass.open()
    client = build_client(strategy: Shopify, site: bypass_server(server))
    {:ok, client: client, server: server}
  end

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "client created with default values" do
    result = Shopify.client()
    assert result.authorize_url == "/admin/oauth/authorize"
  end

  test "client created with custom site url" do
    result = Shopify.client(site: "https://someshop.myshopify.com")
    assert result.site == "https://someshop.myshopify.com"
  end

  test "client created with .io shopify domain" do
    result = Shopify.client(site: "https://devshop.myshopify.io")
    assert result.site == "https://devshop.myshopify.io"
  end

  test "authorize_url! should generate, at minimum, site ++ authorize_url" do
    result = Shopify.authorize_url!()
    assert String.contains?(result, "https://myshopify.com/admin/oauth/authorize?")
  end

  test "authorize_url! should accept custom site parameters" do
    result = Shopify.authorize_url!([], site: "https://devshop.myshopify.io")
    assert String.contains?(result, "https://devshop.myshopify.io/admin/oauth/authorize?")
  end
end

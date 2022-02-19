defmodule OAuth2.Provider.Shopify do
  @moduledoc """
  OAuth2 strategy for Shopify
  """
  use OAuth2.Strategy

  @client_defaults [
    strategy: __MODULE__,
    client_id: nil,
    client_secret: nil,
    redirect_uri: nil,
    site: "https://myshopify.com",
    authorize_url: "/admin/oauth/authorize",
    token_url: "/admin/oauth/access_token"
  ]

  @default_scopes [
    scope:
      "read_products, write_products, read_customers, write_customers, read_orders, write_orders, read_inventory, write_inventory, read_locations"
  ]

  @doc """
  Construct a client for requests to Shopify.
  """
  def client(opts \\ []) do
    opts =
      @client_defaults
      |> Keyword.merge(config())
      |> Keyword.merge(opts)
      |> ensure_site_protocol

    OAuth2.Client.new(opts)
  end

  @doc """
  Provides the authorize url for the request phase.
  """
  def authorize_url!(params \\ [], client_opts \\ []) do
    params =
      @default_scopes
      |> Keyword.merge(params)

    client_opts
    |> client
    |> OAuth2.Client.authorize_url!(params)
  end

  @doc """
  Returns an OAuth2.Client with token.
  """
  def get_token!(params \\ [], client_opts \\ []) do
    client_opts
    |> client
    |> OAuth2.Client.get_token!(params)
  end

  #
  #
  # Strategy Callbacks
  #
  #

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  @doc """
  Retrieves the shop's configuration from Shopify `/shop.json` endpoint.
  """
  def get_shop(client, query_params \\ []) do
    case OAuth2.Client.get(client, "/admin/api/2022-01/shop.json") do
      {:ok, %OAuth2.Response{status_code: 401, body: _body}} ->
        {:error, "Unauthorized"}

      {:ok, %OAuth2.Response{status_code: status_code, body: shop}}
      when status_code in 200..399 ->
        {:ok, shop}

      {:error, %OAuth2.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  #
  #
  # Private
  #
  #

  defp config do
    Application.get_env(:oauth2_shopify, OAuth2.Provider.Shopify)
  end

  defp ensure_site_protocol(config) do
    config
    |> Keyword.merge(site: OAuth2.Provider.Shopify.URL.prefix_protocol(config[:site]))
  end
end

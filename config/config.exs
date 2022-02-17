use Mix.Config

config :logger, level: :info

config :oauth2_shopify, OAuth2.Provider.Shopify,
  client_id: "ZYDPLLBWSK3MVQJSIYHB1OR2JXCY0X2C5UJ2QAR2MAAIT5Q",
  client_secret: "f2a1ed52710d4533bde25be6da03b6e3",
  redirect_uri: "https://example.dev"

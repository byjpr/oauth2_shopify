defmodule OAuth2.Provider.Shopify.URLTest do
  use ExUnit.Case, async: true

  import OAuth2.TestHelpers

  alias OAuth2.Provider.Shopify

  doctest Shopify.URL

  describe "`myshopify_domain?` returns true" do
    test "on https protocol and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("https://someshop.myshopify.com")
      assert result == true
    end

    test "malformed protocol and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("htps://someshop.myshopify.com")
      assert result == true
    end

    test "on http protocol and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("http://someshop.myshopify.com")
      assert result == true
    end

    test "on fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("someshop.myshopify.com")
      assert result == true
    end

    test "on admin path, malformed protocol and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("htts://someshop.myshopify.com/admin")
      assert result == true
    end

    test "on admin path, https protocol and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("https://someshop.myshopify.com/admin")
      assert result == true
    end

    test "on admin path, http protocol and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("http://someshop.myshopify.com/admin")
      assert result == true
    end

    test "on admin path and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("someshop.myshopify.com/admin")
      assert result == true
    end

    test "on extended admin path, https protocol and fully qualified domain name" do
      result =
        Shopify.URL.myshopify_domain?("https://someshop.myshopify.com/admin/test/url/hello")

      assert result == true
    end

    test "on extended admin path, http protocol and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("http://someshop.myshopify.com/admin/test/url/hello")
      assert result == true
    end

    test "on extended admin path and fully qualified domain name" do
      result = Shopify.URL.myshopify_domain?("someshop.myshopify.com/admin/test/url/hello")
      assert result == true
    end
  end

  test "10" do
    result = Shopify.URL.extract_shop_domain("someshop.myshopify.com/admin/test/url/hello")
    assert result == "someshop"
  end

  test "11" do
    result = Shopify.URL.extract_shop_domain("example.myshopify.com/admin/test/url/hello")
    assert result == "example"
  end

  test "12" do
    result = Shopify.URL.extract_shop_domain("example.myshopify.com")
    assert result == "example"
  end

  test "13" do
    result = Shopify.URL.extract_shop_domain("https://example.myshopify.com")
    assert result == "example"
  end

  test "14" do
    result = Shopify.URL.extract_shop_domain("http://example.myshopify.com")
    assert result == "example"
  end

  test "15" do
    result = Shopify.URL.extract_shop_domain("https://hexdocs.pm/fuzzyurl/Fuzzyurl.html#content")
    assert result == false
  end
end

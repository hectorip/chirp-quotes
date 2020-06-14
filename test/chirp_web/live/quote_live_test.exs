defmodule ChirpWeb.QuoteLiveTest do
  use ChirpWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Chirp.Timeline

  @create_attrs %{body: "some body", likes_count: 42, repost_count: 42, username: "some username"}
  @update_attrs %{body: "some updated body", likes_count: 43, repost_count: 43, username: "some updated username"}
  @invalid_attrs %{body: nil, likes_count: nil, repost_count: nil, username: nil}

  defp fixture(:quote) do
    {:ok, quote} = Timeline.create_quote(@create_attrs)
    quote
  end

  defp create_quote(_) do
    quote = fixture(:quote)
    %{quote: quote}
  end

  describe "Index" do
    setup [:create_quote]

    test "lists all quotes", %{conn: conn, quote: quote} do
      {:ok, _index_live, html} = live(conn, Routes.quote_index_path(conn, :index))

      assert html =~ "Listing Quotes"
      assert html =~ quote.body
    end

    test "saves new quote", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.quote_index_path(conn, :index))

      assert index_live |> element("a", "New Quote") |> render_click() =~
               "New Quote"

      assert_patch(index_live, Routes.quote_index_path(conn, :new))

      assert index_live
             |> form("#quote-form", quote: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#quote-form", quote: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.quote_index_path(conn, :index))

      assert html =~ "Quote created successfully"
      assert html =~ "some body"
    end

    test "updates quote in listing", %{conn: conn, quote: quote} do
      {:ok, index_live, _html} = live(conn, Routes.quote_index_path(conn, :index))

      assert index_live |> element("#quote-#{quote.id} a", "Edit") |> render_click() =~
               "Edit Quote"

      assert_patch(index_live, Routes.quote_index_path(conn, :edit, quote))

      assert index_live
             |> form("#quote-form", quote: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#quote-form", quote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.quote_index_path(conn, :index))

      assert html =~ "Quote updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes quote in listing", %{conn: conn, quote: quote} do
      {:ok, index_live, _html} = live(conn, Routes.quote_index_path(conn, :index))

      assert index_live |> element("#quote-#{quote.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#quote-#{quote.id}")
    end
  end

  describe "Show" do
    setup [:create_quote]

    test "displays quote", %{conn: conn, quote: quote} do
      {:ok, _show_live, html} = live(conn, Routes.quote_show_path(conn, :show, quote))

      assert html =~ "Show Quote"
      assert html =~ quote.body
    end

    test "updates quote within modal", %{conn: conn, quote: quote} do
      {:ok, show_live, _html} = live(conn, Routes.quote_show_path(conn, :show, quote))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Quote"

      assert_patch(show_live, Routes.quote_show_path(conn, :edit, quote))

      assert show_live
             |> form("#quote-form", quote: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#quote-form", quote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.quote_show_path(conn, :show, quote))

      assert html =~ "Quote updated successfully"
      assert html =~ "some updated body"
    end
  end
end

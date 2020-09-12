defmodule PixelSmashWeb.PageLiveTest do
  use PixelSmashWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to PixelSmash Arena!"
    assert render(page_live) =~ "Welcome to PixelSmash Arena!"
  end
end

defmodule PixelSmashWeb.PageLiveTest do
  use PixelSmashWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, _page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Upcoming Battles"
  end
end

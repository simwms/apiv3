defmodule Apiv3.PictureView do
  use Apiv3.Web, :view

  def render("index.json", %{pictures: pictures}) do
    %{pictures: render_many(pictures, "picture.json")}
  end

  def render("show.json", %{picture: picture}) do
    %{picture: render_one(picture, "picture.json")}
  end

  def render("picture.json", %{picture: picture}) do
    picture |> ember_attributes |> reject_blank_keys
  end

  def render_pictures(things_with_pictures) do
    things_with_pictures
    |> Enum.flat_map(fn thing_with_pictures -> thing_with_pictures.pictures end)
    |> Enum.reject(&is_nil/1)
    |> render_many("picture.json")
  end

  def ember_attributes(picture) do
    %{
      id: picture.id,
      location: picture.location,
      key: picture.key,
      etag: picture.etag
    }
  end
end

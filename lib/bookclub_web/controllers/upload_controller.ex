defmodule BookclubWeb.UploadController do
  use BookclubWeb, :controller

  alias Bookclub.Upload

  def uploadFile(conn, %{"path" => path, "photo" => upload}) do
    uploadFileName = Upload.create_upload_from_plug_upload(upload, path, "noimage.jpg")
      conn
      |> put_status(200)
      |> json(%{data: uploadFileName})
  end


end

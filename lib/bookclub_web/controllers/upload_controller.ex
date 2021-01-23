defmodule BookclubWeb.UploadController do
  use BookclubWeb, :controller

  alias Bookclub.Upload

  def uploadFile(conn, %{"path" => path, "photo" => upload}) do
    uploadFileName = Upload.create_upload_from_plug_upload(upload, path, "noimage.png")
      conn
      |> put_status(200)
      |> json(%{data: uploadFileName})
  end

  def deleteFile(conn, %{"path" => path, "filename" => newFilename}) do
    rmFile = Upload.delete_img(path, newFilename)
      conn
      |> put_status(200)
      |> json(%{data: rmFile})
  end


end

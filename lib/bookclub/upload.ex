defmodule Bookclub.Upload do

  def upload_directory do
    Application.get_env(:bookclub, :uploads_directory)
  end

  def local_path(folder, filename) do

    [upload_directory(), "#{folder}/#{filename}"]
    |> Path.join()
  end

  def create_upload_from_plug_upload(%Plug.Upload{
    filename: filename,
    path: tmp_path,
    content_type: _content_type
  }, folder, default_img) do

    extension = Path.extname(filename)
    time = DateTime.utc_now() |> DateTime.to_unix()
    filenamee = Path.basename(filename, extension)

    newFilename = "#{filenamee}_#{time}#{extension}"

    with :ok <- File.cp(tmp_path, local_path(folder, newFilename)) do
      newFilename
    else
      {:error, _reason} -> default_img
    end

  end

  # def imgur do
  #   base_url = "https://api.imgur.com/3/image/"
  #   headers = 'Authorization: Client-ID 707b8c3154421ea'
  # end

end

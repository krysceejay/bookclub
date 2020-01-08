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
    content_type: content_type
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

end

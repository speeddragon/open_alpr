defmodule OpenALPR do
  @moduledoc """
  Handle license plate recognition service.

  More documentation in http://doc.openalpr.com/api/?api=cloudapi
  """

  @doc """
  Process image given image file path.
  """
  def recognize(_image_file_path) do
    {:error, :not_implemented}
  end

  @doc """
  Process image given image URL.

  ## Parameters
  * `:country` - Defines the training data used by OpenALPR. "us" analyzes North-American style plates. "eu" analyzes European-style plates. Default: `eu`
  * `:recognize_vehicle` = Keyword.get(opts, :recognize_vehicle, false)
  * `:state` - Corresponds to a US state or EU country code used by OpenALPR pattern
              recognition. For example, using "md" matches US plates against the
              Maryland plate patterns. Using "fr" matches European plates against
              the French plate patterns. Default: `fr`
  * `:return_image` - If set to `true`, the image you uploaded will be encoded in base64 and sent back along with the response. Default: `false`
  * `:topn` - The number of results you would like to be returned for plate candidates and vehicle classifications. Default: `10`
  * `:prewarp` - Prewarp configuration is used to calibrate the analyses for the angle of a particular camera.
              More information is available here http://doc.openalpr.com/accuracy_improvements.html#calibration
  """
  def recognize_url(image_url, opts \\ []) do
    query_params = generate_query_params(image_url, opts)

    "#{get_base_url!()}/recognize_url"
    |> HTTPoison.post("", [], params: query_params)
    |> case do
      {:ok, %HTTPoison.Response{body: body}} ->
        # Improve structure assign
        response = Jason.decode!(body, keys: :atoms)
        object = struct(OpenALPR.Response, response)

        if object.error === false do
          {:ok, object}
        else
          {:error, object.error}
        end

      {:error, response} ->
        # Improve error handling
        {:error, response}
    end
  end

  @doc """
  Process image given image base64 string
  """
  def recognize_bytes(_image_base64) do
    {:error, :not_implemented}
  end

  def config() do
    "#{get_base_url!()}/recognize_url"
    |> HTTPoison.get()
    |> case do
      {:ok, %HTTPoison.Response{body: body}} ->
        # Improve structure assign
        {:ok, Jason.decode!(body, keys: :atoms)}

      {:error, response} ->
        {:error, response}
    end
  end

  defp get_base_url!() do
    Application.get_env(:open_alpr, :url, "https://api.openalpr.com/v2")
  end

  defp get_secret_key!() do
    Application.fetch_env!(:open_alpr, :api_key)
  end

  defp generate_query_params(image_url, opts) do
    country = Keyword.get(opts, :country, "eu")
    recognize_vehicle = Keyword.get(opts, :recognize_vehicle, false)
    state = Keyword.get(opts, :state, "pt")
    return_image = Keyword.get(opts, :return_image, false)
    topn = Keyword.get(opts, :topn, 10)
    prewarp = Keyword.get(opts, :prewarp)

    recognize_vehicle_value = if recognize_vehicle, do: 1, else: 0
    return_image_value = if return_image, do: 1, else: 0

    %{
      "image_url" => image_url,
      "secret_key" => get_secret_key!(),
      "recognize_vehicle" => recognize_vehicle_value,
      "country" => country,
      "state" => state,
      "return_image" => return_image_value,
      "topn" => topn,
      "prewarp" => prewarp
    }
  end
end

defmodule OpenALPRTest do
  use ExUnit.Case, async: true
  doctest OpenALPR

  @apikey "apikey"
  setup do
    bypass = Bypass.open()

    Application.put_env(:open_alpr, :url, endpoint_url(bypass.port))
    Application.put_env(:open_alpr, :api_key, @apikey)

    {:ok, bypass: bypass}
  end

  describe "Recognize" do
    test "Valid result", %{bypass: bypass} do
      image_url = "https://www.example.com/random_image.jpg"

      Bypass.expect(bypass, fn conn ->
        assert "country=eu&image_url=#{URI.encode_www_form(image_url)}&prewarp=&recognize_vehicle=0&return_image=0&secret_key=#{
                 @apikey
               }&state=pt&topn=10" ==
                 conn.query_string

        assert "/v2/recognize_url" ==
                 conn.request_path

        assert "POST" == conn.method

        Plug.Conn.resp(conn, 200, valid_response())
      end)

      {:ok, result} = OpenALPR.recognize_url(image_url)
      assert length(result.results) == 1
      assert Enum.at(result.results, 0) |> Map.get(:plate) == "7880LG"
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/v2"

  defp valid_response() do
    ~s({
      "credit_cost": 1,
      "credits_monthly_total": 2000,
      "credits_monthly_used": 3,
      "data_type": "alpr_results",
      "epoch_time": 1574472366561,
      "error": false,
      "img_height": 960,
      "img_width": 528,
      "processing_time": {
        "plates": 64.41183471679688,
        "total": 376.0160000019823
      },
      "regions_of_interest": [
        {"height": 960, "width": 528, "x": 0, "y": 0}
      ],
      "results": [
        {
          "candidates": [
            {
              "confidence": 93.51598358154297,
              "matches_template": 0,
              "plate": "7880LG"
            }
          ],
          "confidence": 93.51598358154297,
          "coordinates": [
            {"x": 330, "y": 581},
            {"x": 442, "y": 560},
            {"x": 443, "y": 593},
            {"x": 332, "y": 616}
          ],
          "matches_template": 0,
          "plate": "7880LG",
          "plate_index": 0,
          "processing_time_ms": 19.039260864257813,
          "region": "eu-nl",
          "region_confidence": 69,
          "requested_topn": 10,
          "vehicle_region": {
            "height": 384,
            "width": 384,
            "x": 144,
            "y": 315
          }
        }
      ],
      "uuid": "",
      "version": 2
    })
  end
end

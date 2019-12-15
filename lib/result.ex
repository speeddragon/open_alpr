defmodule OpenALPR.Result do
  defstruct [
    :plate,
    :confidence,
    :vehicle_region,
    :region,
    :plate_index,
    :processing_time_ms,
    :candidates,
    :coordinates,
    :matches_template,
    :requested_topn
  ]
end

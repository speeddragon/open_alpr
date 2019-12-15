defmodule OpenALPR.Response do
  defstruct [
    :uuid,
    :data_type,
    :epoch_time,
    :processing_time,
    :img_height,
    :img_width,
    :results,
    :credits_monthly_used,
    :version,
    :credits_mohtly_total,
    :error,
    :regions_of_interest,
    :credit_cost
  ]
end

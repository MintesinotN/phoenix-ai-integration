defmodule OpenaiPhoenix.Ai.Assistant do
  alias OpenaiPhoenix.Ai.OpenaiHelper

  def generate_text(prompt), do: OpenaiHelper.generate_text(prompt)
end

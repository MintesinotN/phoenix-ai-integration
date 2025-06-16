defmodule OpenaiPhoenix.Ai.Assistant do
  alias OpenaiPhoenix.Ai.OpenaiHelper

  def generate_text(prompt, context \\ []), do: OpenaiHelper.generate_text(prompt, context)
end

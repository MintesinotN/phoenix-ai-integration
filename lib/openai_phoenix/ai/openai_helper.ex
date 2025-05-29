defmodule OpenaiPhoenix.Ai.OpenaiHelper do
  @api_url "https://api.openai.com/v1/chat/completions"

  def generate_text(prompt) do
    
    api_key =
    case System.get_env("OPENAI_API_KEY") do
      nil -> raise "OPENAI_API_KEY not configured"
      key -> String.trim(key)
    end

    headers = [
      {"Authorization", "Bearer #{api_key}"},
      {"Content-Type", "application/json"}
    ]

    body = %{
      model: "gpt-3.5-turbo",
      messages: [%{role: "user", content: prompt}],
      temperature: 0.7
    } |> Jason.encode!()

    Finch.build(:post, @api_url, headers, body)
    |> Finch.request(OpenaiPhoenix.Finch)
    |> handle_response()
  end

  defp handle_response({:ok, %{status: 200, body: body}}),
    do: {:ok, Jason.decode!(body)}
  defp handle_response({:ok, %{body: body}}),
    do: {:error, Jason.decode!(body)["error"]}
  defp handle_response({:error, reason}),
    do: {:error, reason}
end

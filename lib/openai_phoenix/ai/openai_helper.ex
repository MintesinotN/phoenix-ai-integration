defmodule OpenaiPhoenix.Ai.OpenaiHelper do
  @api_url "https://api.openai.com/v1/chat/completions"
  @default_model "gpt-3.5-turbo"
  @default_temperature 0.7

  def generate_text(prompt, context \\ []) do
    api_key =
      case System.get_env("OPENAI_API_KEY") do
        nil -> raise "OPENAI_API_KEY not configured"
        key -> String.trim(key)
      end

    headers = [
      {"Authorization", "Bearer #{api_key}"},
      {"Content-Type", "application/json"}
    ]

    messages = build_messages(context, prompt)

    body = %{
      model: @default_model,
      messages: messages,
      temperature: @default_temperature
    } |> Jason.encode!()

    Finch.build(:post, @api_url, headers, body)
    |> Finch.request(OpenaiPhoenix.Finch)
    |> handle_response()
    |> case do
      {:ok, response} -> {:ok, response, messages ++ [extract_assistant_message(response)]}
      {:error, reason} -> {:error, reason}
    end
  end

  defp build_messages(context, prompt) do
    # Convert existing context to message format
    Enum.map(context, fn
      %{"role" => role, "content" => content} -> %{role: role, content: content}
      %{role: role, content: content} -> %{role: role, content: content}
    end) ++ [%{role: "user", content: prompt}]
  end

  defp extract_assistant_message(%{"choices" => [%{"message" => message}]}), do: message
  defp extract_assistant_message(_), do: nil

  defp handle_response({:ok, %{status: 200, body: body}}),
    do: {:ok, Jason.decode!(body)}
  defp handle_response({:ok, %{body: body}}),
    do: {:error, Jason.decode!(body)["error"]}
  defp handle_response({:error, reason}),
    do: {:error, reason}
end

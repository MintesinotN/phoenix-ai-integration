defmodule OpenaiPhoenixWeb.ChatLive do
  use OpenaiPhoenixWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, messages: [], context: [], prompt: "")}
  end

  def handle_event("update_prompt", %{"prompt" => prompt}, socket) do
    {:noreply, assign(socket, prompt: prompt)}
  end

  def handle_event("submit_prompt", %{"prompt" => prompt}, socket) do
    # Add user message to UI immediately
    socket = socket
             |> update(:messages, fn msgs -> msgs ++ [%{"role" => "user", "content" => prompt}] end)
             |> assign(:prompt, "")  # Clear the input field

    case OpenaiPhoenix.Ai.Assistant.generate_text(prompt, socket.assigns.context) do
      {:ok, response, new_context} ->
        message = response["choices"] |> List.first() |> Map.get("message")
        socket = socket
                 |> update(:messages, fn msgs -> msgs ++ [message] end)
                 |> assign(:context, new_context)
        {:noreply, socket}

      {:error, reason} ->
        error_msg = %{"role" => "assistant", "content" => "Error: #{inspect(reason)}"}
        {:noreply, update(socket, :messages, fn msgs -> msgs ++ [error_msg] end)}
    end
  end

  def handle_event("clear_chat", _, socket) do
    {:noreply, assign(socket, messages: [], context: [], prompt: "")}
  end
end

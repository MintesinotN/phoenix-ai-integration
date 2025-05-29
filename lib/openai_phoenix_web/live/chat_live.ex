defmodule OpenaiPhoenixWeb.ChatLive do
  use OpenaiPhoenixWeb, :live_view

  # Mount function
  def mount(_params, _session, socket) do
    {:ok, assign(socket, messages: [], prompt: "")}
  end

  # Event handler
  def handle_event("submit_prompt", %{"prompt" => prompt}, socket) do
    {:ok, response} = OpenaiPhoenix.Ai.Assistant.generate_text(prompt)
    message = response["choices"] |> List.first() |> Map.get("message")
    {:noreply, update(socket, :messages, fn msgs -> msgs ++ [message] end)}
  end

  # Render function (if not using .heex template)
  # def render(assigns) do
  #   ~H"""
  #   <div class="chat-box">
  #     <%= for msg <- @messages do %>
  #       <p><%= msg["content"] %></p>
  #     <% end %>
  #   </div>

  #   <form phx-submit="submit_prompt">
  #     <input type="text" name="prompt" placeholder="Ask OpenAI..." />
  #     <button type="submit">Send</button>
  #   </form>
  #   """
  # end
end

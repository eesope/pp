defmodule DoomFireWeb.DoomFireLive do
  use DoomFireWeb, :live_view

  require Logger

  alias DoomFireWeb.DoomFire

  def render(assigns) do
    ~H"""
    <div>
      <h1>DOOM's fire</h1>
      <%= @width %> x <%= @height %>
      <table cellpadding="0" cellspacing="0" style="margin: 10px auto;">
        <tr :for={y <- 0..(@height-1)}> 
          <td :for={x <- 0..(@width-1)} 
              class={"pixel color_#{@fire[{x, y}]}"}></td>
        </tr>
      </table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(70, self(), :tick)

    {fire_data, width, height} = DoomFire.create_fire_data_structure(60, 35)
    fire_data = DoomFire.create_fire_source(fire_data, width, height, 20)

    assigns = %{fire: fire_data, width: width, height: height}
    {:ok, assign(socket, assigns)}
  end

  def handle_info(:tick, socket) do
    width = socket.assigns.width
    height = socket.assigns.height
    fire = socket.assigns.fire
    fire_data = DoomFire.calculate_fire_propagation(fire, width, height)

    assigns = %{fire: fire_data, width: width, height: height}
    {:noreply, assign(socket, assigns)}
  end
end

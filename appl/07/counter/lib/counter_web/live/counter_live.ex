defmodule CounterWeb.CounterLive do
  use CounterWeb, :live_view
  alias Phoenix.PubSub

  # _params similar to params in Phoenix (contains query params, path params)
  def mount(_params, _session, socket) do
    if connected?(socket),
      do: PubSub.subscribe(Counter.PubSub, "CounterLive") # pubsub, topic
    count = Counter.Worker.value()
    {:ok, assign(socket, count: count, updated: time())}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mv-4 text-4xl font-extrbold">
      Counter: {@count}
    </h1>
    <div>
      <.button phx-click="inc">+</.button>
      <.button phx-click="dec">-</.button>
    </div>
    <div>
      Updated: {@updated}
    </div>
    """
  end

  def handle_event("inc", _value, socket) do
    Counter.Worker.inc()
    PubSub.broadcast(Counter.PubSub, "CounterLive", {:value_changed, time()})
    {:noreply, socket}
  end

  def handle_event("dec", _value, socket) do
    Counter.Worker.dec()
    # pubsub, topic, message
    PubSub.broadcast(Counter.PubSub, "CounterLive", {:value_changed, time()}) 
    {:noreply, socket}
  end

  def handle_info({:value_changed, time}, socket) do
    count = Counter.Worker.value()
    {:noreply, socket |> assign(count: count) |> assign(updated: time)}
  end

  defp time() do
    DateTime.utc_now() |> to_string
  end
end

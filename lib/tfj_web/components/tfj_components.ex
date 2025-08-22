defmodule TfjComponents do
  use Phoenix.Component
  use Gettext, backend: TfjWeb.Gettext
  use TfjWeb, :live_view

  @doc """
  Cell-shaded button built by me :)

  ## Examples
  <.button>Action</.button>
  """
  attr :rest, :global, include: ~w(href navigate patch method download name value disabled)
  attr :class, :string
  attr :variant, :string, values: ~w(primary)
  slot :inner_block, required: true

  def button(%{rest: rest} = assigns) do
    variants = %{
      "primary" => "border-1 border-red-500 bg-red-200 p-1 text-red-500",
      "neutral" => "border-1 border-black bg-slate p-1 text-black"
    }

    assigns =
      assign_new(assigns, :class, fn ->
        [Map.fetch!(variants, assigns[:variant])]
      end)

    if rest[:href] || rest[:navigate] || rest[:patch] do
      ~H"""
      <.link class={@class} {@rest}>{render_slot(@inner_block)}</.link>
      """
    else
      ~H"""
      <button class={@class} {@rest}>{render_slot(@inner_block)}</button>
      """
    end
  end

  def header(assigns) do
    ~H"""
    <header class="w-full p-3 border-b-1 border-red-300 border-slate flex items-center justify-between">
      <.link navigate={~p"/"}>
        <h1 class="text-xl">
          <span class="text-red-300">t</span>rying to <span class="text-red-300">f</span>ind a <span class="text-red-300">j</span>ob
        </h1>
      </.link>
      <div>
        <TfjComponents.button variant="neutral">get in touch w/ me</TfjComponents.button>
        <.link navigate={~p"/jobs"}>
          <TfjComponents.button variant="primary">get me a job!</TfjComponents.button>
        </.link>
      </div>
    </header>
    """
  end
end

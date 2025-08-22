defmodule Tfj.Crawlers.Linkedin do
  @moduledoc """
  A simple LinkedIn crawler using Crawly.
  """
  use Crawly.Spider

  @impl Crawly.Spider
  def base_url(), do: "https://www.linkedin.com"

  @impl Crawly.Spider
  def init(slug) do
    [
      start_urls: [
        "https://www.linkedin.com/in/#{slug}/"
      ],
      middlewares: [
        {Crawly.Middlewares.DomainFilter, domains: ["linkedin.com"]},
        Crawly.Middlewares.UniqueRequest,
        Crawly.Middlewares.UserAgent,
        Crawly.Middlewares.FollowRedirects
      ],
      pipelines: [
        {Crawly.Pipelines.JSONEncoder, extension: "jl"},
        Crawly.Pipelines.WriteToFile, # writes to `crawly_results` folder by default
      ],
      request_options: [recv_timeout: 30_000]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    IO.inspect(response, label: "LinkedIn Response Body")
  end
end

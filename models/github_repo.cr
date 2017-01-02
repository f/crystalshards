require "json"
require "html"

VERSION_CACHE = TimeCache(String, String).new(12.hours)

class GithubRepo
  JSON.mapping({
    name: { type: String },
    html_url: { type: String },
    full_name: { type: String },
    description: { type: String, nilable: true },
    stargazers_count: { type: Int32 },
    owner: Owner,
    pushed_at: { type: Time, converter: Time::Format.new("%FT%TZ") },
    forks: { type: Int32 },
    private: { type: Bool },
  })

  def name
    HTML.escape @name
  end

  def html_url
    HTML.escape @html_url
  end

  def description
    if description = @description
      HTML.escape(Emoji.emojize(description))
    else
      nil
    end
  end

  def latest_release
    VERSION_CACHE.fetch("version_#{full_name}") do
      client = HTTP::Client.new("api.github.com", 443, true)
      client.basic_auth ENV["GITHUB_USER"], ENV["GITHUB_KEY"]
      headers = HTTP::Headers.new
      headers["User-Agent"] = "crystalshards"
      response = client.get("/repos/#{full_name}/releases", headers)
      p "pulling release of #{full_name}..."
      releases = JSON.parse(response.body)
      if releases.size > 0
        releases[0]["tag_name"].to_s
      else
        response = client.get("/repos/#{full_name}/tags", headers)
        p "release not found, pulling tag of #{full_name}..."
        tags = JSON.parse(response.body)
        if tags.size > 0
          tags[0]["name"].to_s
        else
          ""
        end
      end
    end
  end

  struct Owner
    JSON.mapping({
      login: {type: String},
      avatar_url: {type: String},
    })

    def login
      HTML.escape @login
    end
  end
end

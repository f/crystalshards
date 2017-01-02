require "ecr/macros"

class Views::Index
  @repos_count : Int32
  @total_count : Int32
  @crystal_repos : Array(GithubRepo)
  @trending_repos : Array(GithubRepo)
  @popular_repos : Array(GithubRepo)
  @recent_repos : Array(GithubRepo)
  @page : Int32
  @sort : String
  @filter : String

  getter :trending_repos, :popular_repos, :recent_repos, :crystal_repos, :repos_count, :sort, :filter, :total_count, :page

  def initialize(total_repos, repos, trending, popular, recently, sort, filter, page, params : Kemal::ParamParser)
    @repos_count = repos.total_count
    @crystal_repos = repos.items
    @trending_repos = trending.items
    @popular_repos = popular.items
    @recent_repos = recently.items
    @total_count = total_repos
    @page = page
    @params = params

    @sort = sort
    @filter = filter
    @now = Time.utc_now
  end

  def human_time(time)
    diff = (@now - time)
    if diff < 5.minutes
      "just now"
    elsif diff < 1.hour
      "#{diff.total_minutes.to_i} minutes ago"
    elsif diff < 2.hours
      "1 hour ago"
    elsif diff < 1.day
      "#{diff.total_hours.to_i} hours ago"
    elsif diff < 2.days
      "1 day ago"
    else
      "#{diff.total_days.to_i} days ago"
    end
  end

  ECR.def_to_s "./views/index.ecr"
end

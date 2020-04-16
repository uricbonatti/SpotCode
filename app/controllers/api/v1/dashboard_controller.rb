class Api::V1::DashboardController < ApplicationController

  def index
    load_recent_heard
    load_recommendations
  end
  private
  def load_recent_heard
    @recent_albuns = current_user.recently_heards.order('created_at DESC').limit(4).map(&:album)
  end
  def load_recommendations
    heard_categories = @recent_albuns.map(&:category)
    if heard_categories.present?
      Album.joins(:category, :songs).where(category: heard_categories).order('songs.played_count').select('distinct albuns.*').limit(12)
    else
      Album.all.sample(12)
  end
end

module ApplicationHelper
  def options_for_video_ratings(default_selected = nil)
    options_for_select(["5", "4", "3", "2", "1"].map { |r| [r + (r.to_i > 1 ? " Stars" : " Star"), r]}, default_selected)
  end
end

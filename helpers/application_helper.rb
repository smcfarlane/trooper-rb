module ApplicationHelper
  CLERK_PUB_KEY = ENV['CLERK_PUB_KEY'].freeze

  def clerk_pub_key
    CLERK_PUB_KEY
  end
end

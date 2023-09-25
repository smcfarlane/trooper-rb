require 'clerk'

Clerk.configure do |c|
  c.logger = AppLogger # if omitted, no logging
end

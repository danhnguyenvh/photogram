require "instagram"

Instagram.configure do |config|
  config.client_id = "6fe103c0b8354362ad41d500374227d4"
  config.client_secret = "2926b5cbbc9a4ecdb8b15c35aa2ea4c7"
end

CALLBACK_URL = "http://localhost:3000/session/callback"

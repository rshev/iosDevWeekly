module TargetFormPostable
    def post_form(uri, params)
        begin
            Net::HTTP.post_form(uri, params)
        rescue
            puts "❌"
            return
        end
        puts "✅"
    end
end

class InstapaperTarget
    include TargetFormPostable

    INSTAPAPER_API_ADD_URI = URI("https://www.instapaper.com/api/add")

    def post(title, url)
        params = {
            "username" => Config::INSTAPAPER_USERNAME,
            "password" => Config::INSTAPAPER_PASSWORD,
            "url" => url,
            "title" => title
        }

        post_form(INSTAPAPER_API_ADD_URI, params)
    end
end

class PocketTarget
    include TargetFormPostable

    POCKET_API_ADD_URI = URI("https://getpocket.com/v3/add")

    def post(title, url)
        params = {
            "url" => url,
            "title" => title,
            "tags" => Config::POCKET_TAGS,
            "consumer_key" => Config::POCKET_APP_CONSUMER_KEY,
            "access_token" => Config::POCKET_ACCESS_TOKEN
        }

        post_form(POCKET_API_ADD_URI, params)
    end
end

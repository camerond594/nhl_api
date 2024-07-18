require "uri"
require "net/http"

class NhlApi::Client
    API_WEB_BASE_URL = "https://api-web.nhle.com"
    API_BASE_URL = "https://api.nhle.com"
    API_VER = "/stats/rest"
    API_WEB_API_VER = "/v1"
    DEFAULT_PORT = 443

    def get_roster(team:, year:)
        uri = URI.parse("#{API_WEB_BASE_URL}#{API_WEB_API_VER}/roster/#{team}/#{year}/")
        response = get_request(uri: uri)   
        JSON.parse(response.read_body)
    end

    def player_stats(player_id:)
        uri = URI.parse("#{API_WEB_BASE_URL}#{API_WEB_API_VER}/player/#{player_id}/landing/")
        response = get_request(uri: uri)   
        JSON.parse(response.read_body)
    end

    private

    def get_request(uri:)
        request = Net::HTTP::Get.new(uri.request_uri)
        connection(host: uri.host).request(request)
    end

    def connection(host:)
        http = Net::HTTP.new(host, DEFAULT_PORT)
        http.use_ssl = true
        http
    end
end
module ApiResponse
  class ResponseData
    class << self
      def api_version
        @api_version ||= File.read(File.join(File.dirname(__FILE__), '../../version')).strip
      end

      def current_time
        Time.now.in_time_zone(ENV['TIMEZONE'] || 'UTC')
      end

      def success(data, status_code = 200)
        {
          data: data,
          api_version: api_version,
          timestamp: current_time.iso8601,
          status: status_code
        }.to_json
      end

      def error(message, status_code = 400)
        {
          error: message,
          api_version: api_version,
          timestamp: current_time.iso8601,
          status: status_code
        }.to_json
      end
    end
  end
end 
module AviraUpdateMirrors
  class Download

    include HTTParty
    # http_proxy 'PROXY_IP', PROXY_PORT
    # default_timeout 60
    default_timeout 10

    attr_reader :error, :response, :downloads_dir, :download_file_path

    def initialize(base_url, options = {})
      @base_url = base_url
      @base_dir = options[:base_dir] || Dir.pwd
      @downloads_dir = File.join(@base_dir, 'tmp', Time.now.strftime("%Y%m%d%H%M%S%L"))
      FileUtils.mkdir_p @downloads_dir
      @error = nil
      @download_file_path = nil

      self.class.base_uri @base_url
    end

    def perform(expand_url)
      @expand_url = expand_url.gsub("\\", "/")
      @error = nil
      @download_file_path = File.join(@downloads_dir, @expand_url)
      FileUtils.mkdir_p File.dirname(@download_file_path)
      begin
        @response = self.class.get(@expand_url)
      rescue Timeout::Error
        @error = 'timeout'
      else
        case @response.code
        when 200
          File.open(@download_file_path, "wb+") do |file|
            file.write @response.body
          end
        when 404
          @error = '404'
        when 500...600
          @error = '500'
        end
      end
    end

    def downloaded?
      !@error
    end

  end
end
module AviraUpdateMirrors
  class ParseInfo

    attr_reader :files, :need_download_files

    def initialize(options)
      @wwwroot_dir = options[:wwwroot_dir]
      @downloads_dir = options[:downloads_dir]
      @files = {}
      @need_download_files = {}
      
    end

    def generate_files_list(&block)
      Dir[File.join(@downloads_dir, "**", "*.info.gz")].each do |info_gz|
        yield "  reading and parsing #{info_gz}"
        parse_xml(read_gz(info_gz))
      end
    end

    def check_files_md5(&block)
      yield "  checking #{@files.size} files md5"
      @files.each do |fname, fzipmd5|
        fpath = File.join(@wwwroot_dir, fname)
        unless File.exist?(fpath)
          @need_download_files[fname] = fzipmd5
        else
          unless Digest::MD5.file(fpath) == fzipmd5.downcase
            @need_download_files[fname] = fzipmd5
          end
        end
      end
    end

    private
      def read_gz(gzip_file)
        Zlib::GzipReader.open(gzip_file) do |gz|
          gz_body = gz.read rescue ""
          gz.close
          return gz_body
        end
      end

      def parse_xml(xmlstr)
        xml = Document.new(xmlstr)
        moduleType = []
        xpathquery = "//MODULE"
        XPath.each(xml,xpathquery) do |element|
          moduleType << element.attribute('NAME').to_s
        end
        moduleType.uniq

        fname = []
        fzipmd5 = []

        moduleType.each do |m|
          d = XPath.first(xml,"//MODULE[@NAME='#{m}']")
          fp = XPath.first(d,"SOURCE").attribute('value').to_s.gsub(/\\/,"/").gsub(/\.\//,"/")
          next if XPath.first(d,"FILE/NAME") == nil
          XPath.each(d,"FILE/NAME") do |f|
            fname << f.attribute('value').to_s
          end
          XPath.each(d,"FILE/ZIPMD5") do |sum|
            fzipmd5 << sum.attribute('value').to_s
          end
          (0..fname.length-1).each do |n|
            @files[fp.to_s + fname[n].to_s + ".gz"] = fzipmd5[n]
          end
        end
      end

  end
end
require "httparty"
require 'fileutils'
require "zlib"
require 'rexml/document'
include REXML
require "digest/md5"

require "avira_update_mirrors/version"
require "avira_update_mirrors/configuration"
require "avira_update_mirrors/download"
require "avira_update_mirrors/parse_info"

module AviraUpdateMirrors

  def self.configure
    yield Configuration
  end

  def self.mirror
    @@base_dir = Dir.pwd
    @@wwwroot_dir = File.join(@@base_dir, Configuration.wwwroot_dir)
    @@download = {}

    FileUtils.mkdir_p @@wwwroot_dir

    Configuration.products.each_with_index do |product, n|
      product.each do |product_name, product_config|
        puts "mirroring #{product_name}"

        puts "  choice update_server"
        product_config["update_servers"].each do |update_server|

          puts "    try #{update_server}"
          download = Download.new(update_server, :base_dir => @@base_dir)
          download.perform(product_config["idx_master"])

          if download.downloaded?
            @@download[product_name] = download
            puts "      use this update_server #{update_server}"
            break
          else
            next
          end
        end

        raise "all update_servers invalidation" unless @@download[product_name]

        # download all idxes and parse
        product_config["idxes"].each do |idx|
          puts "  downloading #{idx}"
          @@download[product_name].perform(idx)
        end

        
        parse_info = ParseInfo.new(:wwwroot_dir => @@wwwroot_dir, :downloads_dir => @@download[product_name].downloads_dir)
        parse_info.generate_files_list do |msg|
          puts msg
        end
        parse_info.check_files_md5 do |msg|
          puts msg
        end

        puts "  #{parse_info.need_download_files.size} files need download"
        parse_info.need_download_files.each do |file_name, file_zip_md5|
          puts "  downloading #{file_name}"
          @@download[product_name].perform(file_name)
          unless Digest::MD5.file(@@download[product_name].download_file_path) == file_zip_md5.downcase
            raise "downloaded file md5 error!"
          end
        end

        puts "  copy downloaded files to wwwroot_dir and destroy downloaded files"
        FileUtils.cp_r File.join(@@download[product_name].downloads_dir, "."), @@wwwroot_dir
        FileUtils.rm_rf @@download[product_name].downloads_dir
      end
    end
  end

end

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

require "pry"

module AviraUpdateMirrors

  def self.configure
    yield Configuration
  end

  def self.mirror
    @@base_dir = Dir.pwd
    @@wwwroot_dir = File.join(@@base_dir, Configuration.wwwroot_dir)

    Configuration.products.each_with_index do |product, n|
      product.each do |product_name, product_config|
        product_config["update_servers"].each do |update_server|
          download = Download.new(update_server, :base_dir => @@base_dir)
          download.perform(product_config["idx_master"])

          if download.downloaded?
            # use this update_server download all idxes
            product_config["idxes"].each do |idx|
              download.perform(idx.gsub("\\", "/"))
            end

            # generate need_download_files
            parse_info = ParseInfo.new(:wwwroot_dir => @@wwwroot_dir, :downloads_dir => download.downloads_dir)
            parse_info.need_download_files.each do |file_name, file_zip_md5|
              download.perform(file_name)
              unless Digest::MD5.file(download.download_file_path) == file_zip_md5.downcase
                raise "downloaded file md5 error!"
              end
            end

            # break this product
            break
          else
            # put code and error
            # try next update_server
            next
          end
        end
      end
    end
  end

end

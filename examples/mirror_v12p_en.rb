#!/usr/bin/env ruby

require 'avira_update_mirrors'

AviraUpdateMirrors.configure do |config|
  config.wwwroot_dir = "wwwroot"
  config.products = [
              "v12p_en" => {
                "update_servers" => %w`
                  http://80.190.130.226/update
                `,
                "idx_master" => %q`/idx/master.idx`,
                "idxes" => %w`
                  /idx/wks_avira12-win32-en-pepr.idx
                  /idx/wks_avira12-win32-en-pepr.info.gz
                  /idx/webcat-common-int.info.gz
                  /idx/vdf.info.gz
                  /idx/rdf-common-int.info.gz
                  /idx/ave2-win32-int.info.gz
                  /idx/wks_avira12-win32-en-pepr-info.info.gz
                  /idx/scanner-win32-int.info.gz
                `
              }
            ]
end

AviraUpdateMirrors.mirror

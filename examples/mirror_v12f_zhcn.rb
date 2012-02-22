#!/usr/bin/env ruby

require 'avira_update_mirrors'

AviraUpdateMirrors.configure do |config|
  config.wwwroot_dir = "wwwroot"
  config.products = [
              "v12f_zhcn" => {
                "update_servers" => %w`
                  http://80.190.143.227/update
                `,
                "idx_master" => %q`/idx/master.idx`,
                "idxes" => %w`
                  /idx/wks_avira12-win32-zhcn-pecl.idx
                  /idx/wks_avira12-win32-zhcn-pecl.info.gz
                  /idx/webcat-common-int.info.gz
                  /idx/vdf.info.gz
                  /idx/rdf-common-int.info.gz
                  /idx/ave2-win32-int.info.gz
                  /idx/wks_avira12-win32-zhcn-pecl-info.info.gz
                  /idx/peclkey-common-int.info.gz
                  /idx/scanner-win32-int.info.gz
                `
              }
            ]
end

AviraUpdateMirrors.mirror

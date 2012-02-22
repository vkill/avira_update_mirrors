# AviraUpdateMirrors

Mirror avira update

## Installation

Add this line to your application's Gemfile:

    gem 'avira_update_mirrors'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install avira_update_mirrors

## Usage

see `examples`

### about configure

see your update log, like this

    16:43:57 [UPD] [INFO]       Checking whether newer files are available.
    16:43:57 [UPD] [INFO]       Select update server 'http://119.97.137.178/update'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/master.idx' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/wks_avira12-win32-en-pecl.idx' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/wks_avira12-win32-en-pecl.info.gz' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/webcat-common-int.info.gz' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/vdf.info.gz' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/rdf-common-int.info.gz' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/ave2-win32-int.info.gz' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/wks_avira12-win32-en-pecl-info.info.gz' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/peclkey-common-int.info.gz' to 'xx'.
    16:43:57 [UPD] [INFO]       Downloading of 'http://119.97.137.178/update/idx/scanner-win32-int.info.gz' to 'xx'.

"http://119.97.137.178/update" is your update_servers
"idx/master.idx" is your idx_master
"idx/wks_avira12-win32-en-pecl.idx" and more is your idxes

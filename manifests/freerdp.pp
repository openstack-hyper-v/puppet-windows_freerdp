# Class: windows_freerdp
#
# This module downloads then installs Cloudbase Solutions FreeRDP tools
#
# Parameters: none
#
# Actions:
#

class windows_freerdp{

  $rdp_url  = 'http://www.cloudbase.it/downloads/FreeRDP_win32_x86_20121010.zip'
  $rdp_file = 'FreeRDP_win32_x86_20121010.zip'

  windows_common::download{'FreeRDP-cloudbase':
    url  => $rdp_url,
    file => $rdp_file,
  }

  windows_7zip::commands::extract_archive{'FreeRDP-Powershell-Module':
    archivefile => $rdp_file,
  }

  exec { 'install-freerdp-powershell-cmdlet':
    command  => 'Import-Module -Global .\\PSFreeRDP.ps1',
    require  => Windows::7zip::Commands::Extract_archive['FreeRDP-Powershell-Module'],
    provider => powershell,
    cwd      => "${::temp}\\FreeRDP",
  }

}

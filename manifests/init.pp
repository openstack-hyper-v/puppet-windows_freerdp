# == Class: windows_freerdp
#
# This module downloads then installs Cloudbase Solutions FreeRDP tools 
# 
# Parameters: none 
#
# === Parameters
#
# Document parameters here.
#
# [rdp_url]
#   Specifies a url to a zip file containing the Windows FreeRDP files.
#   This defaults to a nightly build of FreeRDP produced by Cloudbase Solutions.
#
# [rdp_file]
#   The name of the zip file to be saved on the local machine.
#
# [ps_module_loc]
#   A fully-qualified directory in the PSModule search path.
#
# [windows_dir]
#   The root Windows directory.  ('C:\Windows' in default installations.)
#
#
# === Examples
#
#  class { windows_freerdp:
#    rdp_url  => 'http://some.other/FreeRDP/build.zip',
#    rdp_file => 'free-rdp.zip'
#  }
#
# === Authors
#
# Tim Rogers <tiroger@microsoft.com>
#
# === Copyright
#
# Copyright 2014 Tim Rogers.
#
class windows_freerdp (

  $rdp_url       = 'http://www.cloudbase.it/downloads/wfreerdp_nightly_build.zip',
  $rdp_file      = 'FreeRDP.zip',
  $ps_module_loc = 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules',
  $windows_dir   = 'C:\Windows',

){
  
  windows_common::remote_file{'FreeRDP-cloudbase':
    source      => $rdp_url,
    destination => "${::temp}\\${rdp_file}",
  }

  windows_7zip::extract_file{'FreeRDP-Powershell-Module':
    file        => $rdp_file,
    destination => "${::temp}",
    require     => Windows_common::Remote_file['FreeRDP-cloudbase'],
  }

  file {"${ps_module_loc}\\FreeRDP":
    ensure  => directory,
  }
  
  file {"${ps_module_loc}\\FreeRDP\\FreeRDP.psm1":
    ensure  => file,
    source  => "${::temp}\\Hyper-V\FreeRDP.psm1",
    require => File["${ps_module_loc}\\FreeRDP"], Windows_7zip::Extract_file['FreeRDP-Powershell-Module'],
  }
  
  file {"${windows_dir}\\wfreerdp.exe":
    ensure  => file,
    source  => "${::temp}\\wfreerdp.exe",
    require => Windows_7zip::Extract_file['FreeRDP-Powershell-Module'],
  }

#  # Clean up
#  file {"${::temp}\\Hyper-V":
#    ensure  => absent,
#    force   => true,
#    require => File["${ps_module_loc}\\FreeRDP\\FreeRDP.psm1"]
#  }
#  file {"${::temp}\\wfreerdp.exe":
#    ensure  => absent,
#    require => File["${windows_dir}\\wfreerdp.exe"],
#  }
#  file {"${::temp}\\${rdp_file}":
#    ensure  => absent,
#    require => File["${::temp}\\Hyper-V", "${::temp}\\wfreerdp.exe"],
#  }
  

}

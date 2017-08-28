#
# Cookbook:: windows_uk_config
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# reboot is needed to apply the new locale
reboot 'restart_computer' do
  action :nothing
  reason 'Change of locale'
  delay_mins 1
end

# Install DSC Package Management Provider Resource
powershell_script 'Install_PackageManagementProviderResource' do
  code <<-EOH
  Install-Module -Name 'PackageManagementProviderResource' -RequiredVersion 1.0.3 -Force
  EOH
  guard_interpreter :powershell_script
  not_if <<-EOH
    $result =  Get-Module -Name 'PackageManagementProviderResource' -ListAvailable
    ($result.Name -eq 'PackageManagementProviderResource')
  EOH
end

# Install the xTimeZone module for the PSGallery
dsc_resource 'Install_xTimeZone' do
  resource :PSModule
  property :Ensure, 'Present'
  property :Name, 'xTimeZone'
  property :Repository, 'PSGallery'
  property :InstallationPolicy, 'Trusted'
  property :RequiredVersion, '1.6.0.0'
end

# Install the systemlocal module

dsc_resource 'Install_SystemLocaleDSC' do
  resource :PSModule
  property :Ensure, 'Present'
  property :Name, 'SystemLocaleDsc'
  property :Repository, 'PSGallery'
  property :InstallationPolicy, 'Trusted'
  property :RequiredVersion, '1.1.0.0'
end

# Set timezone to GMT
dsc_resource 'Set_TimeZone_GMT' do
  resource :xTimeZone
  property :TimeZone, 'GMT Standard Time'
  property :IsSingleInstance, 'Yes'
end

dsc_resource 'Set_System_Locale_EN_GB' do
  resource :SystemLocale
  property :SystemLocale, 'EN-GB'
  property :IsSingleInstance, 'Yes'
  notifies :reboot_now, 'reboot[restart_computer]', :immediately
end

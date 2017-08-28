#
# Cookbook:: windows_uk_config
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'windows_server_localisation::uk' do
  context 'When all attributes are default, on Windows 2016' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2012r2')
      runner.converge(described_recipe)
    end
    #todo stub get-module command
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'Installs the xTimezone module' do
      expect(chef_run).to run_dsc_resource('Install_xTimezone')
    end

    it 'Sets the timezone to GMT' do
      expect(chef_run).to run_dsc_resource('Set_Timezone_GMT')
    end
  end
end

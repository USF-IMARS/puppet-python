require 'beaker-rspec'
require 'beaker/puppet_install_helper'

UNSUPPORTED_PLATFORMS = [ 'windows' ]

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    if host.is_pe?
      install_pe
    else
      run_puppet_install_helper
    end
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
	puppet_module_install(:source => proj_root, :module_name => 'python')
    hosts.each do |host|
      on host, puppet('module install puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module install stahnma-epel'), { :acceptable_exit_codes => [0,1] }
    end
  end
end

require 'spec_helper'

# Ensure the packages are installed
%w(knockd).each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe service('knockd') do
  it { should be_enabled }
  it { should be_running }
end

# Check config readable, writable settings

%w(/etc/knockd.conf /etc/default/knockd).each do |f|
  describe file(f) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end
end

describe file('/etc/default/knockd') do
  its(:content) { should match(/START_KNOCKD\s*=\s*1/) }
  its(:content) { should match(/KNOCKD_OPTS\s*=\s*"-i eth1"/) }
end

# Check that the sequences were created

describe file('/etc/knockd.conf') do
  it { should_not be_readable.by('others') }
  it { should contain '[ssh]' }
  it { should contain '[http]' }
  it { should contain 'sequence = 123:tcp,124:tcp,125:tcp' }
  it { should contain 'sequence = 1123:tcp,1124,1125' }
end

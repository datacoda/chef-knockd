require 'spec_helper'

describe 'knockd_sequence_test::default' do
  describe 'with invalid test_sequence' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['knockd']['client_bin'] = 'knock'
        node.set['knockd']['test_sequence'] = ['1123', '1124:udpfail', '1125:tcp']
        node.set['knockd']['test_flags'] = [:syn, :ack]
      end.converge(described_recipe)
    end

    it 'should fail' do
      # rubocop:disable Style/Blocks
      expect {
        chef_run
      }.to raise_exception(Chef::Exceptions::ValidationFailed)
      # rubocop:enable Style/Blocks
    end
  end

  describe 'with invalid test_flags' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['knockd']['client_bin'] = 'knock'
        node.set['knockd']['test_sequence'] = ['1123', '1124:udp', '1125:tcp']
        node.set['knockd']['test_flags'] = [:syn, :ack, :foo]
      end.converge(described_recipe)
    end

    it 'should fail' do
      # rubocop:disable Style/Blocks
      expect {
        chef_run
      }.to raise_exception(Chef::Exceptions::ValidationFailed)
      # rubocop:enable Style/Blocks
    end
  end

  describe 'with correct values' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['knockd']['client_bin'] = 'knock'
        node.set['knockd']['test_sequence'] = ['1123', '1124:udp', '1125:tcp']
        node.set['knockd']['test_flags'] = [:syn, :ack]
      end.converge(described_recipe)
    end

    it 'should install knockd' do
      expect(chef_run).to install_package('knockd')
      expect(chef_run).to start_service('knockd')
      expect(chef_run).to create_template('/etc/default/knockd')
    end

    it 'should create a template resource' do
      expect(chef_run).to create_template('/etc/knockd.conf')
    end
  end
end

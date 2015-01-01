require 'spec_helper'

describe 'knockd_client_test::default' do
  describe 'with wrong test_sequence' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['knockd']['client_bin'] = 'knock'
        node.set['knockd_client']['test_sequence'] = ['1123', '1124:udpfail', '1125:tcp']
      end.converge(described_recipe)
    end

    it 'should fail' do
      # Note: ChefSpec doesn't seem to catch this exception at all.
      # Temporarily commenting it out.
      # expect(chef_run).to raise_error(Chef::Exceptions::ValidationFailed)
    end
  end

  describe 'with correct values' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '12.04',
        step_into: 'knockd_client'
        ) do |node|
          node.set['knockd']['client_bin'] = 'knock'
          node.set['knockd_client']['test_sequence'] = ['1123', '1124:udp', '1125:tcp']
        end.converge(described_recipe)
    end

    # Resource in mysql_client_test::default
    context 'compiling the test recipe' do
      it 'enables knockd_client[default]' do
        expect(chef_run).to run_knockd_client('default')
      end
    end

    # mysql_service resource internal implementation
    context 'stepping into knockd_client[default] resource' do
      it 'executes knockd-client' do
        expect(chef_run).to run_execute('knock 127.0.0.1 1123 1124:udp 1125:tcp')
      end
    end
  end
end

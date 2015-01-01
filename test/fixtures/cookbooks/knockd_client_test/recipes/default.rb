# Simple test

knockd_client 'default' do
  ip '127.0.0.1'

  sequence node['knockd_client']['test_sequence']
end

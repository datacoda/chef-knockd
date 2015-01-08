# Simple test

knockd_client 'default' do
  ip '127.0.0.1'

  sequence node['knockd']['test_sequence']
end

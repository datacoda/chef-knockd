# Simple test

include_recipe 'knockd'

knockd_sequence 'ssh' do
  sequence node['knockd']['test_sequence']
  on_open 'ufw allow from %IP% to any port 22'
  tcpflags node['knockd']['test_flags']
end

include_recipe 'firewall'

# open standard ssh port, enable firewall
firewall_rule 'ssh' do
  port 22
  action :create
  notifies :restart, 'firewall[ufw]'
end

firewall 'ufw' do
  action :nothing
end

# knock specific testing setup

include_recipe 'knockd'

knockd_sequence 'ssh' do
  sequence ['123:tcp', '124:tcp', '125:tcp']
  on_open 'ufw allow from %IP% to any port 22'
  tcpflags [:syn, :ack]
end

knockd_sequence 'http' do
  sequence ['1123:tcp', '1124', '1125']
  on_open 'ufw allow from %IP% to any port 80'
  on_close 'ufw delete allow from %IP% to any port 80'
  auto_close 10
  tcpflags :syn
end

knockd_sequence 'https' do
  sequence ['2123', '2124:tcp', '2125:udp']
  on_open 'ufw allow from %IP% to any port 443'
end

# note, this won't do anything since its a loopback
knockd_client 'http' do
  ip node['dev_knock_ip']

  # note: array literal style switch because of rubocop
  sequence %w(1123 1124 1125)
end

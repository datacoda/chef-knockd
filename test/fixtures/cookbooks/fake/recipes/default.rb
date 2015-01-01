include_recipe 'firewall'

# open standard ssh port, enable firewall
firewall_rule 'ssh' do
  port 22
  action :allow
  notifies :enable, 'firewall[ufw]'
end

firewall 'ufw' do
  action :nothing
end

# knock specific testing setup

include_recipe 'knockd'

knockd 'knockknock' do
  action :nothing
  supports [:enable, :disable]
end

knockd_sequence 'ssh' do
  port '123'
  port '124'
  port '125'
  on_open 'ufw allow from %IP% to any port 22'
  tcpflags [:syn, :ack]

  notifies :enable, 'knockd[knockknock]'
end

knockd_sequence 'http' do
  port '1123'
  port '1124'
  port '1125'
  on_open 'ufw allow from %IP% to any port 80'
  on_close 'ufw delete allow from %IP% to any port 80'
  auto_close 10
  tcpflags :syn

  notifies :enable, 'knockd[knockknock]'
end

knockd_sequence 'https' do
  sequence ['2123', '2124:tcp', '2125:udp']
  on_open 'ufw allow from %IP% to any port 443'
  notifies :enable, 'knockd[knockknock]'
end

# note, this won't do anything since its a loopback
knockd_client 'http' do
  ip node['dev_knock_ip']

  # note: array literal style switch because of rubocop
  sequence %w(1123  1124  1125)
end

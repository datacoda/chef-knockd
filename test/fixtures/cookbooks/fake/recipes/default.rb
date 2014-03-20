# Open the SSH port so we retain access

include_recipe 'knockd'
include_recipe 'knockd::monit'

knockd 'knockknock' do
  action    :nothing
  supports [:enable, :disable]
end

knockd_sequence 'ssh' do
  port '123'
  port '124'
  port '125'
  on_open 'echo ssh open'
  tcpflags [:syn, :ack]

  notifies  :enable, 'knockd[knockknock]'
end


knockd_sequence 'http' do
  port '1123'
  port '1124'
  port '1125'
  on_open 'echo http open'
  tcpflags :syn

  notifies  :enable, 'knockd[knockknock]'
end

knockd_sequence 'https' do
  sequence [ '2123', '2124:tcp', '2125:udp' ]
  on_open 'echo https open'
  notifies  :enable, 'knockd[knockknock]'
end
# strange unifi port rules

node.set_unless['iptables']['rules'] = []
ports = [80, 443, 8080, 8443, 8880, 8843, 3478]

ports.each do |p|
  rule = {
    name: "port_#{p}_tdp",
    value: "-A FWR -p tcp -m tcp --dport #{p} -j ACCEPT"
  }
  node.set['iptables']['rules'] << rule if node['iptables']['rules'].select { |r| r[:name] == rule[:name] }.empty?
end

ports.each do |p|
  rule = {
    name: "port_#{p}_udp",
    value: "-A FWR -p udp -m udp --dport #{p} -j ACCEPT"
  }
  node.set['iptables']['rules'] << rule if node['iptables']['rules'].select { |r| r[:name] == rule[:name] }.empty?
end


port_10000 = {
  name: 'port_10000',
  value: '-A FWR -p tcp -m tcp --dport 10000:10010 -m state --state NEW -j ACCEPT'
}
node.set['iptables']['rules'] << port_10000 if node['iptables']['rules'].select { |r| r[:name] == port_10000[:name] }.empty?

port_10001 = {
  name: 'port_10001',
  value: '-A FWR -p tcp -m tcp --sport 10001 --dport 10001 -j ACCEPT'
}
node.set['iptables']['rules'] << port_10001 if node['iptables']['rules'].select { |r| r[:name] == port_10001[:name] }.empty?

include_recipe 'martinb3-base::iptables'

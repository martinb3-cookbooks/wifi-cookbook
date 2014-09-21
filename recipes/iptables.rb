# strange unifi port rules

node.set_unless['iptables']['rules'] = []
ports = [80, 443, 8080, 8443, 8880, 8843, 3478]

ports.each do |p|
  node.set['iptables']['rules'] << {
    name: "port_#{p}",
    value: "-A FWR -p tcp -m tcp --dport #{p} -j ACCEPT"
  }
end

node.set['iptables']['rules'] << {
  name: 'port_10000',
  value: '-A FWR -p tcp -m tcp --dport 10000:10010 -m state --state NEW -j ACCEPT'
}

node.set['iptables']['rules'] << {
  name: 'port_10001',
  value: '-A FWR -p tcp -m tcp --sport 10001 --dport 10001 -j ACCEPT'
}

include_recipe 'martinb3-base::iptables'

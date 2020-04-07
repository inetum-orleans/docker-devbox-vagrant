# Use dnsmasq for .test domains and fix .local domains by bypassing systemd-resolved with resolvconf
sudo sh -c "echo address=/.test/$LOCAL_IP>/etc/dnsmasq.d/test-domain-to-local-ip"
sudo sh -c "echo bind-interfaces>/etc/dnsmasq.d/bind-interfaces" # Fix conflict with systemd-resolve
sudo service dnsmasq restart
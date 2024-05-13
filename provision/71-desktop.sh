#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

echo "## Installing desktop environement"
sudo apt-get install -fy kubuntu-desktop

kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key Autolock --type bool false
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key LockOnResume --type bool false
sudo kwriteconfig5 --file /etc/sddm.conf --group Autologin --key User --type string vagrant

sudo apt-get -y install `check-language-support -l $CONFIG_LANGUAGE`

if (dpkg -l avahi-daemon); then
  # avahi-daemon may cause issues with .local domains
  sudo systemctl disable avahi-daemon
  sudo systemctl stop avahi-daemon

  # purge the package to remove it's reference inside /etc/nsswitch.conf (mdns4 / mdns4_minimal)
  sudo apt-get purge -fy avahi-daemon
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get install -qy virtualbox-guest-dkms virtualbox-guest-x11
#sudo apt-get purge -fy avahi-daemon
#sudo apt-get install -fy resolvconf

echo "## Installing Firefox policies for CA certificates"

sudo mkdir -p "/usr/lib/mozilla"
sudo ln -sfn /usr/local/share/ca-certificates "/usr/lib/mozilla/certificates"

sudo tee /usr/lib/mozilla/update-firefox-certificates.py >/dev/null <<EOF
#!/usr/bin/env python3
# -*- coding: utf-8
import os, json

policies_fp = "/usr/lib/firefox/distribution/policies.json"
certificates_dir = "/usr/lib/mozilla/certificates"

data = None
if not os.path.exists(policies_fp):
    open(policies_fp, 'a').close()
with open(policies_fp, "r", encoding="utf-8") as json_file:
    try:
        data = json.load(json_file)
    except:
        data = {}

    try:
        certs = data['policies']['Certificates']['Install']
    except KeyError:
        if 'policies' not in data:
            data = {'policies': {}}
        if 'Certificates' not in data['policies']:
            data['policies']['Certificates'] = {"ImportEnterpriseRoots": True}
        if 'Install' not in data['policies']['Certificates']:
            certs = []
            data['policies']['Certificates']['Install'] = certs

    print("Installing certificates from %s" % certificates_dir)
    for f in os.listdir(certificates_dir):
        print("Certificate found: %s" % f)
        if f not in certs:
            certs.append(f)

with open(policies_fp, "w", encoding="utf-8") as json_file:
    json.dump(data, json_file, ensure_ascii=False, indent=4)
    
print("Policies files written to %s" % policies_fp)
EOF
sudo chmod +x /usr/lib/mozilla/update-firefox-certificates.py
sudo /usr/lib/mozilla/update-firefox-certificates.py

# TODO: Setup update-firefox-certificates.py as a systemd oneshot service
# TODO: Maybe this script should be removed after fixing the issue https://github.com/mozilla/policy-templates/issues/291
# TODO: After the issue is release, ImportEnterpriseRoots should be enough

echo "## Importing CA Certificates in NSS database (chrome support)"
sudo apt-get install -fy libnss3-tools

for cert in /usr/local/share/ca-certificates/*; do
    echo "Certificate found: ${cert##*/}"
    mkdir -p $HOME/.pki/nssdb
    certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -i "${cert}" -n "${cert##*/}"
done

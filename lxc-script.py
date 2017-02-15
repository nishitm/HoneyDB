import os
import lxc
import time

global server
server = lxc.Container("db-server")

if not server.defined:
	raise Exception("[*] Container is not created!!!\n")
	exit(1)

if not server.running:
	server.start()

time.sleep(5)

if not server.running:
        raise Exception("[*] Container not able to start!!\n")
        exit(1)

if server.running:
	print("[*] Server started\n")

output=os.popen("lxc-ls -f --filter=ubuntu | grep 10.0 | awk '{ print $5 }'").read()
print("[*] IP:",output[:-1])

os.system("lxc-attach -n db-server -- apt-get update")
os.system("lxc-attach -n db-server -- apt-get install aptitude -y")
os.system("lxc-attach -n db-server -- aptitude install debconf-utils -y")
os.system("lxc-attach -n db-server -- debconf-set-selections <<< 'mariadb-server mariadb-server/root_password password n0tActualD13'")
os.system("lxc-attach -n db-server -- debconf-set-selections <<< 'mariadb-server mariadb-server/root_password_again password n0tActualD13'")
os.system("lxc-attach -n db-server -- aptitude install mariadb-server -y")

print("[*] Successfully Done!\n")
exit(0)

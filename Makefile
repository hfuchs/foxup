clean:
	rm -rf */foxup*.deb
server-deb: foxup-server/
	@chmod 0755 foxup-server/DEBIAN/p*
	@dpkg -b foxup-server foxup-server/
client-deb: foxup-client/
	@chmod 0755 foxup-server/DEBIAN/p*
	@dpkg -b foxup-client foxup-client/
debs: client-deb server-deb


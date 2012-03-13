clean:
	rm -rf */foxup*.deb
server-deb: foxup-server/
	@dpkg -b foxup-server foxup-server/
client-deb: foxup-client/
	@dpkg -b foxup-client foxup-client/
debs: client-deb server-deb


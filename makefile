go_sources := $(wildcard *.go */*.go)
c_sources := $(wildcard *.c)
c_headers := $(wildcard *.h)

gopath := $(shell go env GOPATH)
go_deps += $(gopath)/src/github.com/namecoin/pkcs11mod
inputs := $(c_headers) $(c_sources) $(go_sources)

# build the shared object
libnamecoin.so: $(inputs) $(go_deps)
	CGO_ENABLED=1 go build -buildmode c-shared -o $@

all: clean libnamecoin.so moz-ext
	@echo now run "${MAKE} all-install" to install all (requires root)


$(go_deps):
	go get -v -d $@
	go generate $@


# install libnamecoin.h and libnamecoin.so to /usr/local/namecoin/
install:
	mkdir -p /usr/local/namecoin
	install libnamecoin.so /usr/local/namecoin/

.PHONY += clean cleanmoz
clean: cleanmoz
	rm -vf libnamecoin.h libnamecoin.so *.o *.a
cleanmoz:
	rm -rvf moz/web-ext-artifacts

# build extension
moz-ext: cleanmoz
	cd moz && web-ext build


# test-run sandbox firefox
moz-run: cleanmoz
	cd moz && web-ext run --verbose


# install pkcs11 module to mozilla directory (not extension)
moz-install:
	mkdir -p /usr/lib/mozilla/pkcs11-modules/ 
	install moz/namecoin_module.json /usr/lib/mozilla/pkcs11-modules/


# add pkcs11 module to NSS shared database
nss-shared-install:
	./install_nssdb.sh ~/.pki/nssdb


# add pkcs11 module to Firefox's NSS database
nss-firefox-install:
	./install_nssdb.sh ~/.mozilla/firefox/*.default

# install all the things
install-all: install moz-install nss-shared-install
	@echo now the mozilla extension zip file is ready to install on this machine

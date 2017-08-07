INSTALL_DIR = /etc/apache/ssl
BUILD_DIR = build
CA_DIR = $(BUILD_DIR)/ca
OPENSSL = openssl
DAYS = 750
COUNTRY = DE
DOMAIN = behemoth.local

CONFIG_FILE = ssl.config
CA = "Cocoaneheads CA"
CA_KEY = $(CA_DIR)/private/ca.key
CA_CRT = $(BUILD_DIR)/server-ca.crt
CLIENT_KEY = $(BUILD_DIR)/client.key
CLIENT_CSR = $(BUILD_DIR)/client.csr
CLIENT_CRT = $(BUILD_DIR)/client.crt
SERVER_KEY = $(BUILD_DIR)/server.key
SERVER_CSR = $(BUILD_DIR)/server.csr
SERVER_CRT = $(BUILD_DIR)/server.crt
SERIAL = $(CA_DIR)/serial

all:
	@echo "make ssl"
	@echo "make clean"

ssl: $(BUILD_DIR) $(CA_KEY) $(SERVER_CRT) $(SERVER_KEY)

.PHONY: prepare clean

$(BUILD_DIR): prepare
	mkdir $(BUILD_DIR)
	mkdir -m 0700 $(CA_DIR) $(CA_DIR)/certs $(CA_DIR)/crl $(CA_DIR)/newcerts $(CA_DIR)/private
	touch $(CA_DIR)/index.txt

$(CA_KEY): $(BUILD_DIR)
	$(OPENSSL) genrsa -out $@ 4096

$(CA_CRT): $(CA_KEY)
	$(OPENSSL) req -new -x509 -nodes -extensions v3_ca -days $(DAYS) -key $< -out $@ -subj /C=$(COUNTRY)/CN=$(CA)

%.key: $(BUILD_DIR)
	$(OPENSSL) genrsa -des3 -passout "pass:1234test" -out $@ 1024
	mv $@ $@.orig
	$(OPENSSL) rsa -passin "pass:1234test" -in $@.orig -out $@
	rm $@.orig

%.csr: %.key
	$(OPENSSL) req -new -key $< -out $@ -subj /C=$(COUNTRY)/CN=$(DOMAIN)

$(SERVER_CRT): $(SERVER_CSR) $(CA_CRT)
	$(OPENSSL) x509 -req -days $(DAYS) -in $< -signkey $(SERVER_KEY) -CA $(CA_CRT) -CAkey $(CA_KEY) -out $@ -CAcreateserial -CAserial $(SERIAL)
	cp $(SERVER_CRT) $(CA_DIR)/certs

$(CLIENT_CRT): $(CLIENT_CSR) $(CA_CRT)
	$(OPENSSL) x509 -req -days $(DAYS) -in $< -CA $(CA_CRT) -CAkey $(CA_KEY) -set_serial 01 -out $@

clean:
	rm -rf $(BUILD_DIR)

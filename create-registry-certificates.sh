# Replace with what you want
SUBJECT="/C=ES/ST=PO/L=Vigo/O=Registry/OU=Registry/CN=registry"
PASS="registry"

mkdir certs
cd certs
openssl req -new -newkey rsa:4096 -subj $SUBJECT -passout pass:$PASS > registry.csr
openssl rsa -in registry.csr -out registry.key -passin pass:$PASS
openssl x509 -in registry.csr -out registry.crt -req -signkey registry.key -days 10000

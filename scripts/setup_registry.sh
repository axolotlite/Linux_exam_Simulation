#!/bin/bash
#
#use as root
USERNAMES=("redhat")
PASSWORDS=("password")

#package installation
yum install -y podman

#setting up the container registry
mkdir -p /opt/registry/{auth,certs,data}
for idx in ${!USERNAMES[@]};
do
	htpasswd -bBc /opt/registry/auth/htpasswd ${USERNAMES[$idx]} ${PASSWORDS[$idx]}
done
openssl req -subj "/CN=$CLASSROOM_HOSTNAME/O=Mock Exam/C=EG" -newkey rsa:4096 -nodes -sha256 -keyout /opt/registry/certs/domain.key -x509 -days 365 -out /opt/registry/certs/domain.crt
cp /opt/registry/certs/domain.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

podman run --name myregistry \
-p 5000:5000 \
-v /opt/registry/data:/var/lib/registry:z \
-v /opt/registry/auth:/auth:z \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
-v /opt/registry/certs:/certs:z \
-e "REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt" \
-e "REGISTRY_HTTP_TLS_KEY=/certs/domain.key" \
-e REGISTRY_COMPATIBILITY_SCHEMA1_ENABLED=true \
-d \
docker.io/library/registry:latest

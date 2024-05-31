#checkov:skip=CKV_DOCKER_3: "Ensure that a user for the container has been created"
#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"
#checkov:skip=CKV_DOCKER_7: "Ensure the base image uses a non latest version tag"
FROM ubuntu/squid:latest
WORKDIR /etc/squid
COPY squid.conf .

FROM alpine:latest

RUN apk add --no-cache git
RUN apk add --update python3

COPY entrypoint.py /entrypoint.py
RUN chmod +x /entrypoint.py

ENTRYPOINT ["/entrypoint.py"]

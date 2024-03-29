FROM alpine:3.8

RUN mkdir -p /home/app

RUN apk --no-cache add curl \
    && echo "Pulling watchdog binary from Github." \
    && curl -sSL https://github.com/openfaas/faas/releases/download/0.9.14/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && cp /usr/bin/fwatchdog /home/app \
    && apk del curl --no-cache
    
# Add non root user
RUN addgroup -S app && adduser app -S -G app

RUN chown app /home/app

WORKDIR /home/app

USER app
COPY ./echo.sh ./echo.sh
# Populate example here - i.e. "cat", "sha512sum" or "node index.js"
ENV fprocess="./echo.sh"
# Set to true to see request in function logs
ENV write_debug="false"
ENV combine_output='false'
ENV read_timeout=120
ENV write_timeout=120
ENV exec_timeout=120

EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1
CMD [ "fwatchdog" ]

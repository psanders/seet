##
## Build
##
FROM node:lts-alpine as builder
LABEL Pedro Sanders <fonosterteam@fonoster.com>

COPY . /build
WORKDIR /build

RUN npm install && npm run build && npm pack

##
## Runner
##
FROM node:lts-alpine as runner

ARG SCENARIOS=/seet.json
ENV SCENARIOS=${SCENARIOS}
ENV TINI_VERSION=v0.19.0
COPY --from=builder /build/seet-*.tgz ./
RUN apk add --update sipp=3.6.0-r2 \
  && npm install -g seet-*.tgz

ENTRYPOINT ["sh", "-c"]
CMD [ "seet" ]
# ---- Base Node ----
FROM node:21-alpine3.17 AS base
RUN apt-get update
RUN apt-get install openssl
LABEL image=LeoDog896/prisma-studio:latest \
  maintainer="Tristan F. <leodog896@gmail.com>" \
  contributor="Timothy Miller <tim.miller@preparesoftware.com>" \
  base=alpine

#
# ---- Dependencies ----
FROM base AS dependencies
COPY package.json ./
COPY package-lock.lock ./

RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production

#
# ---- Release ----
FROM base AS release
COPY --from=dependencies /node_modules ./node_modules
COPY prisma-introspect.sh .
RUN chmod +x prisma-introspect.sh
EXPOSE $PRISMA_STUDIO_PORT
ENTRYPOINT ["/bin/sh", "prisma-introspect.sh"]
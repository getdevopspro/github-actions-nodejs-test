# Set default base image
ARG ARG_IMAGE_FROM=docker.io/node:22

# -----------------------------------------------------------------------------
# Stage 1: Nodeapp build
# -----------------------------------------------------------------------------
FROM ${ARG_IMAGE_FROM} AS nodeapp-base

WORKDIR /home/node/app

# -----------------------------------------------------------------------------
# Stage 2: Nodeapp build
# -----------------------------------------------------------------------------
FROM nodeapp-base AS nodeapp-build

COPY static /home/node/app/static
COPY *.json *.ts *.js *.cjs /home/node/app/
COPY src /home/node/app/src

RUN --mount=type=cache,target=/home/node/.npm,sharing=locked \
    npm ci --ignore-scripts && \
    npm run build && \
    npm prune --omit=dev

# -----------------------------------------------------------------------------
# TARGET 1: Nodeapp dev image
# -----------------------------------------------------------------------------
FROM nodeapp-base AS nodeapp-dev

ARG NODE_ENV=development
ARG NODE_UID=1000
ENV NODE_UID=$NODE_UID
ENV NODE_ENV=$NODE_ENV
ENV NPM_CONFIG_PREFIX=/home/node/app/.npm
ENV NPM_CONFIG_CACHE=/home/node/app/.npm

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -ex && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
      # Alphabetical order per best practice
      # (To make finding packages in lists easier and to help avoid duplicates)
      git \
      curl \
      make \
      tar \
      unzip \
      zip

RUN usermod -u $NODE_UID node && \
    groupmod -g $NODE_UID node && \
    usermod -d /home/node -m node && \
    chown -R $NODE_UID:$NODE_UID /home/node

USER $NODE_UID

CMD ["/bin/bash"]

# -----------------------------------------------------------------------------
# TARGET 2: Nodeapp image
# -----------------------------------------------------------------------------
FROM nodeapp-base AS nodeapp

ARG ENV=production
ARG PORT=3000
ENV NODE_ENV=$ENV

COPY --from=nodeapp-build --chown=node:root /home/node/app/package.json .
COPY --from=nodeapp-build --chown=node:root /home/node/app/node_modules node_modules/
COPY --from=nodeapp-build --chown=node:root /home/node/app/build build/

EXPOSE $PORT

CMD [ "node", "-r", "dotenv/config", "build" ]

# -----------------------------------------------------------------------------
# TARGET 3: Final image
# -----------------------------------------------------------------------------
FROM nodeapp AS final

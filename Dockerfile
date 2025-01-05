FROM node:18-alpine AS base

FROM base AS builder
RUN apk add --no-cache libc6-compat
RUN apk update

WORKDIR /app
RUN yarn global add turbo@1.10.16 sharp

# Copy the entire monorepo
COPY . .
RUN turbo prune --scope=@setup-nextjs/web --docker

FROM base AS installer
RUN apk add --no-cache libc6-compat
RUN apk update
WORKDIR /app

# Copy the full monorepo structure
COPY . .
RUN yarn install --frozen-lockfile

# Build the project and its dependencies
RUN yarn turbo run build --filter=@setup-nextjs/web

FROM base AS runner
WORKDIR /app/apps/web

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
USER nextjs

COPY --from=installer /app/apps/web/next.config.js .
COPY --from=installer /app/apps/web/package.json .
# COPY --from=installer --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=installer --chown=nextjs:nodejs /app/apps/web/.next/static ./.next/static
COPY --from=installer --chown=nextjs:nodejs /app/apps/web/public ./public

CMD ["node", "server.js"]

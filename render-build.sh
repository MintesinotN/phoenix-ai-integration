#!/usr/bin/env bash
set -o errexit

mix deps.get --only prod
MIX_ENV=prod mix compile

# Install and build assets
cd assets && npm install && npm run deploy
cd ..

# Deploy assets
MIX_ENV=prod mix assets.deploy

# Generate digest for assets
MIX_ENV=prod mix phx.digest

# Create release
MIX_ENV=prod mix release

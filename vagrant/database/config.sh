#!/bin/sh

if [ -z "$POSTGRES_PASSWORD" ]; then
    export POSTGRES_PASSWORD = 'MySQL can rott.'
fi

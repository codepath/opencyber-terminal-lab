#!/bin/sh
# deploy the app build to staging
rsync -a ./build/ deploy@staging:/var/www/app/
echo "deployed $(date)"

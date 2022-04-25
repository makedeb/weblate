#!/usr/bin/env bash
set -eux
hw_url='hunterwittenborn.com'
makedeb_url='makedeb.org'
deploy_dir='/var/www/weblate.makedeb.org'

# Delete the env file if it exists.
rm environment
touch environment

# Generate our env file.
cat <<EOF > environment
WEBLATE_EMAIL_HOST=mailcow.${hw_url}
WEBLATE_EMAIL_PORT=465
WEBLATE_EMAIL_HOST_USER=weblate@${makedeb_url}
WEBLATE_EMAIL_HOST_PASSWORD=${weblate_email_password}
WEBLATE_EMAIL_USE_TLS=0
WEBLATE_EMAIL_USE_SSL=1
WEBLATE_SERVER_EMAIL=weblate@${makedeb_url}
WEBLATE_DEFAULT_FROM_EMAIL=weblate@${makedeb_url}
WEBLATE_SITE_DOMAIN=weblate.${makedeb_url}
WEBLATE_ADMIN_NAME=Hunter Wittenborn
WEBLATE_ADMIN_EMAIL=hunter@${hw_url}
WEBLATE_TIME_ZONE=America/Chicago
WEBLATE_ENABLE_HTTPS=1
WEBLATE_GITHUB_USERNAME=kavplex
WEBLATE_GITHUB_TOKEN=${weblate_github_token}
WEBLATE_DEFAULT_COMMITTER_EMAIL=kavplex@hunterwittenborn.com
WEBLATE_DEFAULT_COMMITTER_NAME=Kavplex
WEBLATE_AUTO_UPDATE=true
WEBLATE_ALLOWED_HOSTS=*
WEBLATE_ENABLE_AVATARS=0
POSTGRES_PASSWORD=${weblate_postgres_password}
POSTGRES_USER=weblate
POSTGRES_DATABASE=weblate
POSTGRES_HOST=database
POSTGRES_PORT=
REDIS_HOST=cache
REDIS_PORT=6379
EOF

# If the deploy directory doesn't exist, create it.
if ! [[ -d "${deploy_dir}" ]]; then
    mkdir "${deploy_dir}"
fi

cd "${deploy_dir}"

# If the Docker Compose file exists in the deploy dir, stop the service.
if [[ -f ./docker-compose.yml ]]; then
    docker compose down --remove-orphans -v
fi

# Remove all files in the repo.
find ./ -mindepth 1 -maxdepth 1 -not -path './data' -exec rm -rf '{}' +

# Go back to the CI's directory and copy over files.
cd -
find ./ -mindepth 1 -maxdepth 1 -not -path './data' -exec cp -R '{}' "${deploy_dir}/{}" \;

# Go to the deploy directory, create needed directories, and bring the containers up.
cd "${deploy_dir}"

for folder in data/{weblate,postgres,redis}; do
    if ! [[ -d "${folder}" ]]; then
        mkdir -p "${folder}"
    fi
done

./service.sh start

# vim: set sw=4 expandtab:

# Server configuration. For a simple site this is just one entry.
role :app, [
    "deployment@rooftop-web1.hosts.errorstudio.com",
    "deployment@rooftop-web2.hosts.errorstudio.com"
]

role :web, [
    "deployment@rooftop-web1.hosts.errorstudio.com",
    "deployment@rooftop-web2.hosts.errorstudio.com"
]

role :db, %w{deployment@rooftop-db-master1.hosts.errorstudio.com}, no_release: true

# Git branch
set :branch, 'master'

#the base domain for this site - is appended to the primary domain for a prelaunch url
set :base_domain, "prelaunch.errorstudio.com"

# the prelaunch domain
set :prelaunch_domain, ->{"#{fetch(:primary_domain)}.#{fetch(:base_domain)}"}

# set the deploy domain to the prelaunch domain
set :deploy_domain, fetch(:primary_domain)

#redirects domains to the primary domain as a 301
set :domain_redirects, %w(~.*\.rooftopcms\.com)

#domains which this site will answer to (i.e. not redirect)
set :site_domains, [fetch(:deploy_domain), "~^.*\.rooftopcms\.io"]

#rewrites in nginx format - useful for specifying hard-coded urls for redirection after launch
set :url_rewrites, {}

#SSL settings
set :ssl_required, true
set :ssl_dir, File.join(File.dirname(__FILE__),"ssl")
set :ssl_cert, "rooftopcms.io.public.crt"
set :ssl_key, "rooftopcms.io.private.key.gpg" #this should be a gpg-encrypted key
set :ssl_dh, "rooftopcms.io.dh.pem.gpg" #this should be a gpg-encrypted key
#set :force_ssl, true #redirect all non-ssl requests to ssl

#http basic auth
set :basic_auth_required, false
set :basic_auth_username, 'testing'
set :basic_auth_password, 'testing'

# Wordpress settings
set :db_host, "rooftop-db-master1.internal"
set :db_prefix, `source public/.env.production; echo $DB_PREFIX`.strip

# Custom env vars for Rooftop
set :custom_env_vars, {
    "REDIS_HOST" => `source public/.env.production; echo $REDIS_HOST`.strip,
    "REDIS_PORT" => `source public/.env.production; echo $REDIS_PORT`.strip,
    "REDIS_DB" => `source public/.env.production; echo $REDIS_DB`.strip,
    "CLOUDFLARE_EMAIL" => `source public/.env.production; echo $CLOUDFLARE_EMAIL`.strip,
    "CLOUDFLARE_API_KEY" => `source public/.env.production; echo $CLOUDFLARE_API_KEY`.strip,
    "CLOUDFLARE_DOMAIN_ZONE" => `source public/.env.production; echo $CLOUDFLARE_DOMAIN_ZONE`.strip,
    "CLOUDFLARE_CDN_DOMAIN_ZONE" => `source public/.env.production; echo $CLOUDFLARE_CDN_DOMAIN_ZONE`.strip

}

after "deploy:finished", "deploy:dr"

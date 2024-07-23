source 'https://rubygems.org'

gem 'itamae', "~> 1.12.6"
gem 'rake'
gem 'serverspec', "~> 2.40.0"
gem 'hashie'
gem 'unix-crypt'
gem 'dotenv', "~> 2.2.1"
gem 'net-ssh', "~> 7.2.0"
gem 'highline', "~> 2.1.0"
gem 'ed25519', "~> 1.3.0"
gem 'bcrypt_pbkdf', "~> 1.1.0"

path = Pathname.new("Gemfile.local")
eval(path.read) if path.exist?

group :test do
  if RUBY_PLATFORM.include?('darwin')
    gem 'growl'
  end
end

rbenv local 2.2.6
gem install bundler
rbenv local 2.3.3
gem install bundler
rbenv local 2.4.0
gem install bundler
rbenv local --unset

rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/4.1.16.gemfile RBENV_VERSION=2.2.6 bundle
rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/4.1.16.gemfile RBENV_VERSION=2.3.3 bundle
rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/4.1.16.gemfile RBENV_VERSION=2.4.0 bundle
rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/4.2.8.gemfile RBENV_VERSION=2.2.6 bundle
rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/4.2.8.gemfile RBENV_VERSION=2.3.3 bundle
rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/4.2.8.gemfile RBENV_VERSION=2.4.0 bundle
rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/5.0.2.gemfile RBENV_VERSION=2.2.6 bundle
rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/5.0.2.gemfile RBENV_VERSION=2.3.3 bundle
rm -rf gemfiles/.bundle
BUNDLE_GEMFILE=gemfiles/5.0.2.gemfile RBENV_VERSION=2.4.0 bundle

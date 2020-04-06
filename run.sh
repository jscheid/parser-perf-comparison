#!/bin/sh

set -exo pipefail

gem install racc

bundle --gemfile=Gemfile.without-patch --path=without-patch
for x in 1 2 3; do
    time bash -c "bundle exec --gemfile=Gemfile.without-patch rubocop --cache false $1 >/dev/null"
done

rm -Rf parser
git clone https://github.com/jscheid/parser
(cd parser && git checkout without-mutable-strings && rake generate)

bundle --gemfile=Gemfile.with-patch --path=with-patch
for x in 1 2 3; do
    time bash -c "bundle exec --gemfile=Gemfile.with-patch rubocop --cache false $1 >/dev/null"
done

rm -Rf parser-2
git clone https://github.com/jscheid/parser parser-2
(cd parser-2 && git checkout without-mutable-strings-2 && rake generate)

bundle --gemfile=Gemfile.with-patch-2 --path=with-patch-2
for x in 1 2 3; do
    time bash -c "bundle exec --gemfile=Gemfile.with-patch-2 rubocop --cache false $1 >/dev/null"
done

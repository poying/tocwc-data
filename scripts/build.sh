#!/usr/bin/env bash
set -e

oldfile="courses.json"
newfile="./build/courses-new.json"

git config --global user.email "poying.me+circleci@gmail.com"
git config --global user.name "circleci"

git branch -D build || true
git checkout -b build
rm -rf build
mkdir build
git checkout origin/gh-pages "$oldfile"
./bin/tocwc-data --progress "$newfile"

mv "$newfile" "$oldfile"
rm -rf build
git add .
git commit -m 'build'
git checkout gh-pages
git checkout build "$oldfile"

if ! git diff-files --quiet --ignore-submodules --
then
  git add "$oldfile"
  git commit -m "circleci ${date}"
  git push
fi

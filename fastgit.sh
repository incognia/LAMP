#!/bin/bash

read MSG

git add .
git commit -m "$(echo $MSG)"
git push

reset
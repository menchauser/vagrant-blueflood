#!/usr/bin/env bash
user=`whoami`
pgrep -u $user -f cassandra | xargs kill -9

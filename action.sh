#!/usr/bin/env bash

COMMAND=$1
ENVFILE=$GITHUB_WORKSPACE/$2
WORKDIR=$GITHUB_WORKSPACE/$3

[ -f $ENVFILE ] && source $ENVFILE
[ -d $WORKDIR ] && cd $WORKDIR

eval $COMMAND

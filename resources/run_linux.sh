#!/bin/sh

BASE=`dirname $0`
java -cp "$BASE/*":"$BASE/students/*" -Djava.library.path="$BASE/lib/" fr.rphstudio.codingdojo.launcher.MainLauncher
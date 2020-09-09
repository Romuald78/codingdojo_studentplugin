#!/bin/bash

FTP_SERVER='ftp://dojouser:codingDoj0@gryt.tech/spaceships/'
BASE=$(dirname $0)
DOWNLOAD_DIR=$BASE/students

function help() {
    cat <<EOF
Usage: $0 -a action -i artefact_id
-a|--action                 download / upload. If download all other students jar will be downloaded.
-j|--jar                    Path to the local Student jar.
-i|--artefactid             Name of the artefact id without the extension (e.g. Student78).
EOF
}

#if [[ $# -ne 2 ]]; then
    #echo "Invalid arguments"
    #exit 1
#fi

while [[ $# -gt 0 ]]; do
    KEY="$1"
    case  $KEY in
        -h|--help)
            DISPLAY_HELP=true
            ;;
        -a|--action)
            ACTION=$2
            shift
            ;;
        -i|--artefactid)
            ARTEFACT_ID=$2
            shift
            ;;
        -j|--jar)
            LOCAL_JAR_FILE=$2
            shift
            ;;
        *)
            ;;
    esac
    shift
done

if [[ $DISPLAY_HELP ]]; then
    help
    exit 0
fi

case $ACTION in
    upload|download) VALID_ACTION=true;;
    *);;
esac

if [[ -z $VALID_ACTION ]]; then
    echo "Invalid action=$ACTION"
    help
    exit 1
fi

if [[ -z $ARTEFACT_ID ]]; then
    echo "Invalid artefactid=$ARTEFACT_ID"
    help
    exit 1
fi

if [[ -z $LOCAL_JAR_FILE ]]; then
    echo "Invalid artefactid=$ARTEFACT_ID"
    help
    exit 1
fi

STUDENT_JAR=$(basename $LOCAL_JAR_FILE)
echo $STUDENT_JAR

if [[ $ACTION = "download" ]]; then
    for F in $(curl --list-only $FTP_SERVER); do
        if [[ $F = $STUDENT_JAR ]]; then
            echo "Skipping student jar $F"
            continue
        fi

        if [[ ! $F = *.jar ]]; then
            echo "Skipping unknown file"
            continue
        fi

        echo "Downloading $F to $DOWNLOAD_DIR/$F"
        curl --insecure $FTP_SERVER$F -o $DOWNLOAD_DIR/$F
    done
fi

if [[ $ACTION == "upload" ]]; then
    echo "Uploading student jar $STUDENT_JAR"
    curl --insecure -T $LOCAL_JAR_FILE $FTP_SERVER$STUDENT_JAR
fi

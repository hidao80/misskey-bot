#!/bin/sh -ue
#
# It is recommended to use environment variables for the API token and visibility.
#

# Generate JSON of the data to be sent from the argument
#   @param  string $1 Misskey API token
#   @param  string $2 Text to be sent
#   @param  string $3 Scope of publication
#   @return string Payload JSON of Misskey submission data
GeneratePayloadJson () {
    echo "{\"i\":\"$1\",\"text\":\"$2\",\"visibility\":\"$3\"}"
}

Usage () {
    cat <<EOL
usage: $0 [-h] [-i <token>] [-t <text>] [-v <visibility>] <url>
    token:      Specify an API token. If not, refer to the environment variable MISSKEY_TOKEN.
    text:       Text to be sent
    visibility: Specify the scope of disclosure. If not, refer to the environment variable MISSKEY_VISIBLITY.
                Possible values are "public", "home", "followers", "specified". Default: "public"
EOL
    exit 1
}


# Parsing command options
# If the "-h" option is specified, usage is displayed and the program exits without sending.
while getopts "i:t:v:h" options; do
    case $options in
        i) token=$OPTARG;;
        t) text=$OPTARG;;
        v) visibility=$OPTARG;;
        h) Usage;;
    esac
done

# Empty check for input
# If no argument is given, the value is obtained from an environment variable.
if [ -z $token ]; then
    token=$MISSKEY_TOKEN
    if [ -z $token ]; then
        echo "ERROR: No token. Note was not sent."
        Usage
    fi
fi
if [ -z $text ]; then
    echo "ERROR: No text. Note was not sent."
    Usage
fi

# Defalut value is "public".
if [ -z $visibility ]; then
    visibility=$MISSKEY_VISIBLITY
fi
if [ -z $visibility ]; then
    visibility="public"
elif [ ! $(echo $visibility | grep -P ^\(public\|home\|followers\|specified\)$) ]; then
    echo "ERROR: This visibility is not available. Note was not sent."
    Usage
fi

# Creating JSON
# echo `GeneratePayloadJson $token $text $visibility`
payload=`GeneratePayloadJson $token $text $visibility`

# Truncate the optional portion.
shift `expr $OPTIND - 1`
url=$1

if [ ! $(echo $url | grep -P ^https://.+$) ]; then
    url=$MISSKEY_URL
    if [ ! $(echo $url | grep -P ^https://.+$) ]; then
        echo "ERROR: No url. Note was not sent."
        Usage
    fi
fi

# Web API Execution
curl -X POST \
    -H "Content-Type: application/json" \
    -d "$payload" \
    $url

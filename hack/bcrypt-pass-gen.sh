#!/bin/sh

## bcrypt passwd generator ##
#############################
CMD=$(which htpasswd 2>/dev/null)
MTIME=$(date +%FT%T%Z)
TEMP="/tmp/$MTIME"
OPTS="-cBC 15"
USERNAME=admin

usage() {
        local script=$(basename $0)
        cat <<EOF
$script: Generate Bcrypt Hashed Passwords using htpasswd and then base64 encode it

Usage: $script username
EOF
        exit 1
}

check_config() {
    if [ -z $CMD ]; then
        printf "Exiting: htpasswd is missing.\n"
        exit 1
    fi

    if [ -z "$USERNAME" ]; then
            usage
    fi
}

check_config $USERNAME
printf "Generating Bcrypt hash for username: $USERNAME\n\n"
 $CMD $OPTS $TEMP $USERNAME
 echo "bcrypt '$(cat $TEMP)'"
 echo "admin.password: '$(cat $TEMP | cut -d':' -f2 | base64)'"
 echo "admin.passwordMtime: '$(echo $MTIME | base64)'"
 rm $TEMP
exit $?
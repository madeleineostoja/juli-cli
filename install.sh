#!/usr/bin/env bash

LINK="/usr/local/bin/juli"

echo "Linking juli-cli.sh to 'juli'"

if [ -f ${LINK} ]; then
  echo "Juli executable exists, overwriting..."
	rm $LINK
fi;

ln -s ${PWD}/juli-cli.sh ${LINK}

echo "Done"
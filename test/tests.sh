#!/bin/bash

# greetings for github runner
if [[ -d /github/home ]]; then
	echo '::notice::Docker action works!'
fi

# Shell check for the most popular script in the world

echo '::echo::on'
echo ::group::Shellcheck for evil.sh
shellcheck test/evil.sh
ret=$?
echo ::endgroup::

if [[ $ret != 0 ]]; then
	echo '::error::Shellcheck failed'
else
	echo '::notice::Shellcheck passed'
fi

exit 0

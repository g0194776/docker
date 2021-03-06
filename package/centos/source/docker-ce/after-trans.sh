if [ $1 -ge 0 ] ; then
    dbefile=/var/lib/docker-engine/distribution_based_engine.json
    URL=https://docs.docker.com/releasenote
    if [ -f "${dbefile}" ] && sed -e 's/.*"platform"[ \t]*:[ \t]*"\([^"]*\)".*/\1/g' "${dbefile}"| grep -v -i community > /dev/null; then
        echo
        echo
        echo
        echo "Warning: Your engine has been activated to Docker Engine - Enterprise but you are still using Community packages"
        echo "You can use the 'docker engine update' command to update your system, or switch to using the Enterprise packages."
        echo "See $URL for more details."
        echo
        echo
        echo
    else
        rm -f /usr/bin/dockerd
        update-alternatives --install /usr/bin/dockerd dockerd /usr/bin/dockerd-ce 1 \
            --slave "${dbefile}" distribution_based_engine.json /var/lib/docker-engine/distribution_based_engine-ce.json
    fi
    # package upgrade scenario, after new files are installed

    # check if docker was running before upgrade
    if [ -f /var/lib/rpm-state/docker-is-active ]; then
        systemctl start docker > /dev/null 2>&1 || :
        rm -f /var/lib/rpm-state/docker-is-active > /dev/null 2>&1 || :
    fi
fi

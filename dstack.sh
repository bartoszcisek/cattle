#!/bin/bash
set -e

cd $(dirname $0)

run()
{
    WAR="$(echo code/packaging/app/target/*war)"
    if [ ! -e "$WAR" ]; then
        mvn clean install
    fi

    WAR=$(readlink -f $WAR)
    mkdir -p runtime
    cd runtime

    exec java -jar $WAR
}

build()
{
    mvn install
    mkdir -p dist/artifacts
    cp code/packaging/app/target/*.war dist/artifacts/dstack.war
    cp tools/docker/wrapper.sh dist/artifacts/dstack.sh
    cp tools/docker/Dockerfile.dist dist/Dockerfile
}

if [ "$#" = "0" ]; then
    echo "Usage:"
    echo -e "\t$0 (build|run)"
    echo -e "\t\t build: Compiles from source"
    echo -e "\t\t run: Starts dStack on port 8080 (will build if no build has been done)"
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case $1 in
    build)
        build
        ;;
    run)
        run
        ;;
    esac
    shift 1
done

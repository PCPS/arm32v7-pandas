FROM sthuber90/arm32v7-numpy:1.16.1

ARG PANDAS_VERSION=0.24.1

COPY ./qemu-arm-static /usr/bin/

RUN buildDeps='build-essential gcc gfortran python3-dev' \
        && apt-get update \
        && apt-get install -y --no-install-recommends $buildDeps  \
        && CFLAGS="-g0 -Wl,--strip-all -I/usr/include:/usr/local/include -L/usr/lib:/usr/local/lib" \
        && pip3 install --no-cache-dir \
        --compile \
        --global-option=build_ext \
        --global-option="-j 4" \
        pandas==${PANDAS_VERSION} \
        && apt-get purge -y --auto-remove $buildDeps \
        && rm -rf /var/lib/apt/lists/*


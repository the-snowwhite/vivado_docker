# Vivado Docker for CI and environment sharing

You should download your vivado version here and your board file folders as board_files.tar.gz.

docker build -t bionic-vitis:2020.1 .

To be able to run the Vivado gui start as:

    docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -itv $(pwd):/work bionic-vitis:2020.1 /bin/bash

    cd /work
    vivado

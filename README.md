# Vivado Docker for CI and environment sharing

To use online dockerhub image (in gui mode):

    cd <a top directory that contains your Vivado projects>
    docker run -itv $(pwd):/work -e DISPLAY=$DISPLAY --net=host -v $HOME/.Xauthority:/home/vivado/.Xauthority -v $HOME/.Xresources:/home/vivado/.Xresources thesnowwhite/bionic-vivado:2019.1 /bin/bash 
    cd /work 
    vivado

---

To build locally:

You should download your vivado version here and your board file folders as board_files.tar.gz.

docker build -t bionic-vivado:2019.1 .

To be able to run the Vivado gui start as:

    cd <a top directory that contains your Vivado projects>
    docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -itv $(pwd):/work bionic-vivado:2019.1 /bin/bash
    cd /work
    vivado

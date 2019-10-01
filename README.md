# Vivado Docker for CI and environment sharing

To use online dockerhub image (in gui mode):

    cd <a top directory that contains your Vivado projects>
    docker run -itv $(pwd):/work -e DISPLAY=$DISPLAY --net=host -v $HOME/.Xauthority:/home/vivado/.Xauthority -v $HOME/.Xresources:/home/vivado/.Xresources thesnowwhite/bionic-vivado:2019.1 /bin/bash 

---

Running Vivado gui directly:

    cd <a top directory that contains your Vivado projects>
    /usr/bin/docker run -itv $(pwd):/work -e DISPLAY=$DISPLAY --net=host -v $HOME/.Xauthority:/home/vivado/.Xauthority -v $HOME/.Xresources:/home/vivado/.Xresources -v $HOME/.Xilinx:/home/vivado/.Xilinx thesnowwhite/bionic-vivado:2019.1 /bin/bash -c 'cd /work && /tools/Xilinx/Vivado/2019.1/bin/vivado'

Your project will be somewhere in the /work folder in the gui

---

To build the docker container locally:

You should download the full vivado installer here and your board file folders to include archived as board_files.tar.gz.

docker build -t bionic-vivado:2019.1 .

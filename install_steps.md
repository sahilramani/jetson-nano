## Basic Installation

1. [Etch the Ubuntu Image using the instructions here](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit)
1. Configure the installation (requires a keyboard/mouse) after the reboot. 
1. `sudo apt update && sudo apt upgrade`
1. `sudo apt install python3-pip python-pip`
1. Reboot Jetson Nano
1. `cd ~`
1. `wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh .`
1. `chmod a+x Miniforge3-Linux-aarch64.sh`
1. `./Miniforge3-Linux-aarch64.sh` (Do not run as root!)
1. Log out and log back on
1. `conda config --set auto_activate_base false`
1. `sudo apt install python3-h5py libhdf5-serial-dev hdf5-tools libpng-dev libfreetype6-dev`
1. `conda create -n jupyter python=3.6`
1. `conda activate jupyter`
1.` conda install matplotlib pandas numpy pillow scipy tqdm scikit-image scikit-learn seaborn cython h5py jupyter ipywidgets -c conda-forge`

## Optional Installation

* __Pytorch__
    * https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-10-now-available/72048
    * `wget https://nvidia.box.com/shared/static/fjtbno0vpo676a25cgvuqc1wty0fkkg6.whl -O torch-1.10.0-cp36-cp36m-linux_aarch64.whl`
    * `sudo apt-get install libopenblas-base libopenmpi-dev `
    * `pip install torch-1.10.0-cp36-cp36m-linux_aarch64.whl`

* __torchvision__:
    * https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-10-now-available/72048
    * `sudo apt-get install libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev`
    * `git clone --branch v0.11.1 https://github.com/pytorch/vision torchvision`
    * `cd torchvision`
    * `export BUILD_VERSION=0.11.1`
    * `python setup.py install --user`

* __TensorRT__:
    * `sudo apt-get install tensorrt`
    * `export PYTHONPATH=/usr/lib/python3.6/dist-packages:$PYTHONPATH`
    * pip install tensorrt

* __TensorFlow__:
    * https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html#install
    * `pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v46 tensorflow`

## General Tips and Tricks 

* __Jetson Nano CLI Only__:
    * If you're only using the Jetson Nano for non-gui purposes, like as a remote inference/training server. This reduces memory pressure of running your OS, and instead focuses on leaving enough memory for your training/inference operations.
    * `jetson_config -p desktop`
    * Select `[B1]` to boot directly to non-gui terminal and require login.
    * NOTE: Only use `[B2]` if you understand what the consequences of this option.
    * This will trigger a Jetson Nano reboot. Click yes.

* __Other Useful Utilities__:
    * __htop__: Improved top command, provides instantaneous stats about your machine/board.
        * [https://htop.dev/](https://htop.dev/)
        * `sudo apt install htop`
    * __tmux__: Terminal Multiplexer. Very useful if you want to start running a command on one terminal instance and check on it periodically on another.
        * [https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)
        * `sudo apt install tmux`
    * __Locate__: Find files easily and instantly.
        * [https://linuxize.com/post/locate-command-in-linux/](https://linuxize.com/post/locate-command-in-linux/)
        * `sudo apt install mlocate`
    * __Jetson Stats__ : More detailed information about your Jetson board
        * [https://github.com/rbonghi/jetson_stats](https://github.com/rbonghi/jetson_stats)
        * `sudo -H pip3 install -U jetson-stats`
        * `sudo systemctl restart jetson_stats.service`
        * `jtop`
        * Reboot your Jetson Nano.

* __Disk Imager__: 
    * Creating a working image for your jetson nano board.
    * windows: [https://win32diskimager.org/#download](https://win32diskimager.org/#download)

* __Cleanup__:
    * `sudo apt autoremove`
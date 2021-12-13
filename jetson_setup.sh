#!/bin/bash
# Copyright (C) 2021, Sahil Ramani <contact@sahilramani.com>
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SCRIPTPATH="$(realpath $0)"

setup_step1()
{
    sudo apt -y update && sudo apt -y upgrade
    sudo apt install -y python3-pip python-pip
}

setup_step2()
{
    cd ~
    mkdir -p install
    cd install
    wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh .
    chmod a+x Miniforge3-Linux-aarch64.sh
    ./Miniforge3-Linux-aarch64.sh
    conda config --set auto_activate_base false
}

setup_step3()
{
    conda config --set auto_activate_base false
    sudo apt install -y python3-h5py libhdf5-serial-dev hdf5-tools libpng-dev libfreetype6-dev
    conda create -n jupyter python=3.6
    conda activate jupyter
    conda install matplotlib pandas numpy pillow scipy tqdm scikit-image scikit-learn seaborn cython h5py jupyter ipywidgets -c conda-forge
}

setup_install_folder()
{
    [ ! -d ~/install] && mkdir -p ~/install 
    cd ~/install
    conda activate jupyter
}

install_pytorch()
{
    setup_install_folder
    wget https://nvidia.box.com/shared/static/fjtbno0vpo676a25cgvuqc1wty0fkkg6.whl -O torch-1.10.0-cp36-cp36m-linux_aarch64.whl
    sudo apt-get install libopenblas-base libopenmpi-dev
    pip install torch-1.10.0-cp36-cp36m-linux_aarch64.whl
}

install_torchvision()
{
    setup_install_folder
    sudo apt-get install -y libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev
    git clone --branch v0.11.1 https://github.com/pytorch/vision torchvision
    cd torchvision
    export BUILD_VERSION=0.11.1
    python setup.py install --user
}

install_tensorflow()
{
    setup_install_folder
    pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v46 tensorflow
}

help()
{
    echo $SCRIPTPATH [-123h] [--pytorch] [--torchvision] [--tensorflow]
    exit 1
}

write_boot_script_step2()
{
    sed -i '$ d' ~/.bashrc
    echo "$SCRIPTPATH $OPTIONS -2" >> ~/.bashrc
    echo "" >> ~/.bashrc
}

write_boot_script_step3()
{
    sed -i '$ d' ~/.bashrc
    echo "$SCRIPTPATH $OPTIONS -3" >> ~/.bashrc
    echo "" >> ~/.bashrc
}

remove_boot_script()
{
    sudo update-rc.d jetsonsetup remove
}

main()
{
    OPTIONS=$(getopt -o 123h: --long pytorch,torchvision,tensorflow -n "$0" -- "$@")
    eval set -- "$OPTIONS"

    echo " [  Jetson Nano Setup v0.1  ]"

    INSTALL_PYTORCH=false
    INSTALL_TORCHVISION=false
    INSTALL_TENSORFLOW=false
    INSTALL_STEP=0
    while true; do
        case "$1" in 
            -1) 
                INSTALL_STEP=1
                ;;
            -2) 
                INSTALL_STEP=2
                ;;
            -3) 
                INSTALL_STEP=3
                ;;
            -h )
                help
                ;;
            --pytorch) 
                INSTALL_PYTORCH=true
                ;;
            --torchvision) 
                INSTALL_TORCHVISION=true
                ;;
            --tensorflow)
                INSTALL_TENSORFLOW=true
                ;;
            -- ) break ;;
        esac
        shift
    done

    if [ $INSTALL_STEP -eq "0" ] ; then
        INSTALL_STEP=1
    fi

    case $INSTALL_STEP in
        1)
            echo "Setting up step 1.."
            setup_step1 &&  write_boot_script_step2 && sudo reboot
            ;;
        2) 
            echo "Setting up step 2.."
            setup_step2 && write_boot_script_step3 && sudo reboot
            ;;
        3)
            echo "Setting up step 3.."
            setup_step3 && remove_boot_script
            ;;
    esac

    if [ INSTALL_PYTORCH = true ]; then 
        echo "Setting up PyTorch.."
        install_pytorch
    fi

    if [ INSTALL_TORCHVISION = true ]; then 
        echo "Setting up Torchvision.."
        install_torchvision
    fi

    if [ INSTALL_TENSORFLOW = true ]; then 
        echo "Setting up TensorFlow.."
        install_tensorflow
    fi
}

main $@
exit 0
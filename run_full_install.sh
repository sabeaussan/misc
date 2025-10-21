#!/bin/bash
# Run all the scripts

set -e
chmod +x docker_install.sh cuda_pre_requisite.sh nvidia_container_install.sh fix_docker_gpu.sh

echo "===== Running Docker installation ====="
echo "***** Running Docker installation *****"
./docker_install.sh

echo "***** Running CUDA installation *****"
./cuda_pre_requisite.sh

echo "***** Running Nvidia-container installation *****"
./nvidia_container_install.sh

echo "Amazing ! Docker and CUDA installed successfully ! I am a f*cking handsome genius <3. But still need to reboot ..."
sudo reboot
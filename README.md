# Setup and install scripts for cloud instances 

## TODO add docker commands and workflow

Connecting to the remote machine:
```bash
ssh user@IPv4
```
with ```user``` and ```IPv4``` set accordingly.

First step is docker+CUDA installation:
```bash
chmod +x run_full_install.sh
./run_full_install.sh
```
If everything went right, the computer should reboot. After that, run:
```bash
 chmod +x fix_docker_gpu.sh
sudo ./fix_docker_gpu.sh
```
Congrats, you are now ready to train some big, fat and juicy neural networks.

### Made with love by Samuel Beaussant

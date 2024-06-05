#!/bin/bash
yay -S aur/lib32-nvidia-utils-beta aur/lib32-opencl-nvidia-beta aur/nvidia-beta-dkms aur/nvidia-settings-beta aur/nvidia-utils-beta aur/opencl-nvidia-beta
systemctl enable nvidia-suspend.service
systemctl enable nvidia-resume.service
systemctl enable nvidia-hibernate.service

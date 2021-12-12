sudo multipass set local.driver=qemu

multipass launch -c 12 -m 6G -d 60G -n docker 20.04 --cloud-init docker.yml

multipass mount /Users docker
multipass mount /tmp docker
multipass mount /private docker
multipass mount /Volumes docker
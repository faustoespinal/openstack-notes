# Install Kubernetes using kubeadm

## On the Master
Commands to execute kubeadm on the master node (Note that 3.28.93.237 is the master IP):

```
sudo -i
source ~centos/.bashrc
systemctl restart docker
systemctl restart kubelet
kubeadm init --skip-preflight-checks --apiserver-advertise-address=192.168.100.7

exit 

# As user centos now...
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Now test kubectl
kubectl get nodes
kubectl get pods --all-namespaces

# DNS is not up and running, so install an overlay network (in this case we'll use weave)
kubectl apply --filename https://git.io/weave-kube-1.6

# After a 1-2 minutes you will see all pods up and running
kubectl get nodes
kubectl get pods --all-namespaces
```

## On each Node/Minion
```
# This line comes from the last printout in the 'kubectl init' install on the master.
sudo -i
source ~centos/.bashrc
systemctl restart docker
systemctl restart kubelet

kubeadm join --token ed288e.3123929ecf971d84 3.28.93.237:6443
```

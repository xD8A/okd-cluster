# Installing OKD4 cluster

Based on https://itnext.io/guide-installing-an-okd-4-5-cluster-508a2631cbee

## Network

| Machine | IP Address | MAC Address |
| --- | --- | --- |
| hub | 192.168.2.1 | 08:00:27:18:00:01 |
| bootstrap | 192.168.2.200 | 08:00:27:18:02:00 |
| master1 | 192.168.2.201 | 08:00:27:18:02:01 |
| master2 | 192.168.2.202 | 08:00:27:18:02:02 |
| worker1 | 192.168.2.204 | 08:00:27:18:02:04 |
| worker2 | 192.168.2.205 | 08:00:27:18:02:05 |

## Users
* root: password: password
* kubeadmin: password: password, ssh private key:
```bash
cat << EOT > /home/kubeadmin/.ssh/id_ed25519 
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBTdbEUV4Nt8w96SQA8gvrg6hjTMiattqcDpEeikghDXwAAAJgbzPerG8z3
qwAAAAtzc2gtZWQyNTUxOQAAACBTdbEUV4Nt8w96SQA8gvrg6hjTMiattqcDpEeikghDXw
AAAECKc4FVC1J43uIgEBAaaWGd/y4g8A+syXbuFBb7lLy3w1N1sRRXg23zD3pJADyC+uDq
GNMyJq22pwOkR6KSCENfAAAADnRvbWlla0BEOEEtTkIwAQIDBAUGBw==
-----END OPENSSH PRIVATE KEY-----
EOT
```

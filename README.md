## Users
* root: password: password
* kubeadmin: password: password, ssh private key:
```bash
cat << EOT > /home/kubeadmin/.ssh/id25519 
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBTdbEUV4Nt8w96SQA8gvrg6hjTMiattqcDpEeikghDXwAAAJgbzPerG8z3
qwAAAAtzc2gtZWQyNTUxOQAAACBTdbEUV4Nt8w96SQA8gvrg6hjTMiattqcDpEeikghDXw
AAAECKc4FVC1J43uIgEBAaaWGd/y4g8A+syXbuFBb7lLy3w1N1sRRXg23zD3pJADyC+uDq
GNMyJq22pwOkR6KSCENfAAAADnRvbWlla0BEOEEtTkIwAQIDBAUGBw==
-----END OPENSSH PRIVATE KEY-----
EOT
```

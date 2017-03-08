# SSHChat

I have no idea what I'm doing but this seems to work

## Installation

You need to create `ssh_dir` inside the root directory with rsa and dsa keys for this to work

```bash
mkdir ssh_dir
ssh-keygen -t rsa -f ssh_dir/ssh_host_rsa_key
ssh-keygen -t dsa -f ssh_dir/ssh_host_dsa_key
```



### Build docker with host SSH key

```sh
ssh-add
DOCKER_BUILDKIT=1 docker build --ssh default .
```


# Common Digital Ocean and Kubernetes commands

### Setup
* Install the Digital Ocean command line tool [doctl](https://github.com/digitalocean/doctl#installing-doctl).
* Install [kubectl](https://kubernetes.io/docs/tasks/tools/).
* Be sure the environment varable `DIGITALOCEAN_ACCESS_TOKEN` is set when running commands below.

### Configure selected cluster / context / namespace
```sh
# List cluster id's and names
doctl kubernetes cluster list

# Add cluster context to kubectl and switch to the newly added context
doctl kubernetes cluster kubeconfig save CLUSTER_ID --alias NEW_KUBECTL_CONTEXT_NAME

# Show current context
kubectl config current-context

# Show available contexts
kubectl config get-contexts

# Show namespaces
kubectl get namespaces

# Switch namespace (so you don't have to use `-n NAMESPACE` everywhere)
kubectl config set-context --current --namespace cert-manager
```

### Inspect pods and their logs
Be sure to configure the correct context and namespace (see above).
To use a namespaces other than the one that's currently configured use `-n NAMESPACE`.

```sh
# Show pods
kubectl get pods

# Show logs for pod
kubectl logs POD_NAME
```

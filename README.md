# To deploy

Replace `$IMAGE_NAME` with your image server, image name and tag

# To run job

```
# First, find the pod name from the deployment
SPARKPOD="$(echo -e "$(kubectl get pods -l component=sparkclient -n=spark -o=custom-columns=:.metadata.name)" | tr -d '[:space:]')"

# Run a shell to the pod
kubectl exec -ti "$SPARKPOD" -n=spark -- bash

# In the shell, run the spark-shell command, pointing to the master
bin/spark-shell --master spark://sparkmaster:7077
```

# To access Spark UI

Spark Master UI
http://localhost:8001/api/v1/proxy/namespaces/spark/services/sparkmaster:8080/

Spark Application UI 
http://localhost:8001/api/v1/proxy/namespaces/spark/services/sparkclient:4040/jobs/

Alternatively k8s port forwarding can be used to access
https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/


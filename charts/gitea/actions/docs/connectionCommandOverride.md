# Using a custom connectionCommand

By default, before the container starts it tries to reach the given giteaRootURL.  
Normally this is done by the busybox image using the wget binary.  

However, due to [Issue #162](https://gitea.com/gitea/helm-actions/issues/162) there has been a change made where we can customize that command.  

Using the `values.yaml` file by default it calls `wget --spider --no-check-certificate <your giteaRootURL>` with a timeout of 10 seconds.  
But with a custom init section like detailed below we can make our check compliant with whatever certificate you have.  

Assuming:
```yaml
enabled: true
giteaRootURL: https://gitea.com
existingSecret: foo
existingSecretKey: bar

init:
  image:
    registry: ""
    repository: alpine
    # Overrides the image tag whose default is the chart appVersion.
    tag: "3.24"
    digest: ""
    pullPolicy: IfNotPresent
    fullOverride: ""

  connectionCommandOverride: "curl -I"
  preConnectionCommandOverride: "apk add curl"
```

This now creates the following template section:

```yaml
        - name: init-gitea
          image: "alpine:latest"
          command:
            - sh
            - -c
            - |
              apk add curl
              echo 'Trying to reach Gitea on https://gitea.com'
              until timeout 10 curl -I https://gitea.com; do
                sleep 3
                echo "Trying again in 3 seconds..."
              done
              echo "Gitea has been reached!"
```

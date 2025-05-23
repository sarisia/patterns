# patterns

### [Devcontainer Local Feature](./devcontainer-local-feature/)

Used when you want to install global tools which depends on
[Devcontainer features](https://containers.dev/features).


### Devcontainer Share Host AWS Credentials

```jsonc
// .devcontainer/devcontainer.json

{
  "initializeCommand": {
    "ensure-aws-dir": "mkdir -p ${localEnv:HOME}/.aws"
  },
  "mounts": [
    "source=${localEnv:HOME}/.aws,target=/home/vscode/.aws,type=bind,consistency=consistent"
  ]
}
```

### Devcontainer Ensure .env File

```jsonc
// .devcontainer/devcontainer.json

{
  "initializeCommand": {
    "ensure-dotenv-file": "cp --no-clobber .env.example .env || true"
  }
}
```

### Devcontainer Preserve Fish Shell History

```jsonc
{
  "mounts": [
    "source=${devcontainerId}-fish-history,target=/home/vscode/.local/share/fish,type=volume"
  ]
}
```

### Devcontainer Non-root User

```
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid 1000 -m vscode
```

Devcontainer automatically updates UID/GID to match host's ones

[Add non-root user to a container](https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#_creating-a-nonroot-user)


### Temporary Non-root

```
RUN su node -c "npm run prod"
```


### Poetry

#### Create cwd .venv

Useful for Devcontainer / CICD caching

```
$ poetry config --local virtualenvs.in-project true
```

#### Disable Package Mode

This will force `poetry install --no-root` and also make
`name` and `version` optional.

https://python-poetry.org/docs/basic-usage/#operating-modes

```toml
# pyproject.toml

[tool.poetry]
package-mode = false
```


### Vite Multiple Entrypoints

Create multiple pages without router (at the sacrifice of performance)

```js
// vite.config.js

import { defineConfig } from "vite"
import { resolve } from "path"

export default defineConfig({
    base: "./",
    build: {
        rollupOptions: {
            input: {
                main: resolve(__dirname, 'index.html'),
                othello: resolve(__dirname, "components", "othello", "index.html")
            }
        },
    }
})
```

### AWS CDK ECS EFS Access Point

It's complicated as fuck

```typescript
        // efs for sqlite
        const fsSg = new ec2.SecurityGroup(
            this,
            "FileSystemSecurityGroup",
            {
                vpc: vpc,
                allowAllOutbound: true,
            },
        );
        const fs = new efs.FileSystem(this, "FileSystem", {
            vpc: vpc,
            vpcSubnets: {
                subnetGroupName: "EFS",
            },
            securityGroup: fsSg
        });
        const fsAccessPoint = fs.addAccessPoint("FileSystemAccessPoint", {
            path: "/laravelefs",
            posixUser: {
                uid: "1000",
                gid: "1000",
            },
            createAcl: {
                ownerGid: "1000",
                ownerUid: "1000",
                permissions: "750",
            }
        })

        const debugTaskSg = new ec2.SecurityGroup(
            this,
            "DebugTaskSecurityGroup",
            {
                vpc: vpc,
                allowAllOutbound: true,
            },
        );
        // debug task -> efs
        fsSg.addIngressRule(debugTaskSg,
            ec2.Port.tcp(efs.FileSystem.DEFAULT_PORT),
            "Allow NFS traffic from debug task",
        )

        const task: ecs.FargateTaskDefinition
        // efs connection
        fs.grantReadWrite(task.taskRole)
        task.addVolume({
            name: "laravelefs",
            efsVolumeConfiguration: {
                fileSystemId: fs.fileSystemId,
                authorizationConfig: {
                    accessPointId: fsAccessPoint.accessPointId,
                    iam: "ENABLED",
                },
                transitEncryption: "ENABLED",
            }
        })
        debugContainer.addMountPoints({
            containerPath: "/mnt/laravelefs",
            sourceVolume: "laravelefs",
            readOnly: false,
        })
```

### Git update remote only on local (insteadOf)

Useful for submodules

```
$ git config --global url."git@github.com:".insteadOf https://github.com/
```


### Caddy Docker Build

```dockerfile
FROM caddy:2-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/route53


FROM caddy:2 AS caddy

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
```


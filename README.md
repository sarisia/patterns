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


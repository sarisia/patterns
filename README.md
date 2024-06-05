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

### Devcontainer Preserve Fish Shell History

```jsonc
{
  "mounts": [
    "source=${devcontainerId}-fish-history,target=/home/vscode/.local/share/fish,type=volume"
  ]
}
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


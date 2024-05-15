# patterns

### [Devcontainer Local Feature](./devcontainer-local-feature/)

Used when you want to install global tools which depends on
[Devcontainer features](https://containers.dev/features).


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


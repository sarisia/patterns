# Devcontainer Local Feature

Used when you want to install global tools which depends on
[Devcontainer features](https://containers.dev/features).

## Case 1: Python + Nodejs CLI

Assume you are developing Python application, but you want to use
some CLI tools which is written with Node.js.

In this case, writing `npm install` in Dockerfile won't work since
base image probably does not have nodejs installed and it's super
annoying to install latest nodejs in Dockerfile yourself.

You can resolve this by:

1. Create python image based Dockerfile
2. Install nodejs devcontainer feature
3. Create devcontainer local feature which depends on nodejs feature

Look at files on this directory to find out more details.

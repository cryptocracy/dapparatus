# Dapparatus

[![platform](https://img.shields.io/badge/platform-Node--RED-red)](https://nodered.org)
[![GitHub version](https://badge.fury.io/gh/dceejay%2Felectron-node-red.svg)](https://badge.fury.io/gh/dceejay%2Felectron-node-red)
[![GitHub license](https://img.shields.io/github/license/dceejay/electron-node-red.svg)](https://github.com/dceejay/electron-node-red/blob/master/LICENSE)

This is an Electron template to embed [Node-RED](https://nodered.org) with an existing Node-RED project to create a native application running Stacks Flows.

This is not intended to be a useful tool as-is, but as a base for you to create your own versions. You will need to edit the `main.js` to suit your application and update the `package.json` file to include your own required nodes and dependencies.

There are several simple switches that can be set in the `NRelectron` section of
the `package.json` file. More significant modifications will require modification
of the `main.js` file. Have fun.

## Wrapping an existing Node-RED project

The `merger.js` utility should be run from within this projects directory and can be pointed at
an existing Node-RED project directory. It will try to copy over and package up the
relevant files into this project ready to install and build - so the simple flow would be

```bash
./merger.js {path to my Node-RED project directory}
yarn
yarn start
```

This uses the `package-template.json` file as the main electron setup - so you should edit any
build parameters, product name, whether you want the app version to be editable, run in kiosk mode, etc in the `NRelectron` section before running.

The app name, version and description are picked up from the package.json file of the original project.

When running using yarn start - the flow file is picked from the current directory. When running as an app (but only if editable), then the flow file is copied into the users `.node-red` directory and is read and written from there. The default name can be changed in the package.json file if required.

**NOTE**: Currently the settings are set around line 110 of the `main.js` file. If you do use any
custom settings then currently you will need to modify this manually.

## Configuring the project for building

This project uses the **electron-builder** project to help build native versions
of Node-RED applications, so please read and become familiar with their
[documentation](https://www.electron.build/) as some basic knowledge is assumed.

As a pre-req, as well as a recent version of node.js, you will need the **yarn** install tool.

```bash
# Clone this repository
git clone https://github.com/cryptocracy/dapparatus.git
# Go into the repository
cd dapparatus
# Install the yarn install tool globally
sudo npm i -g yarn
# Install project dependencies
yarn
```

## Building local runtime

You should then be able to run

```bash
yarn && yarn dist
```

to create a runtime for your local platform.
However - there may be some errors. If so they are usually fairly self explanatory,
and may just require installation of another **npm** or **brew** or **apt** package,
then retry the command.

Runtimes are created in the `dist` directory under the `electron-node-red` project.

### Building for other platforms

Generally you can just add the required parameter to the command

```bash
yarn && yarn dist -w        // for windows (but use multi-platform builder below for building on Mac Catalina)
yarn && yarn dist -l        // for linux
yarn && yarn dist -m        // for mac
```

These will generally fail the first time through, and you will need to install some extra library in order to make it
complete successfully.

The defaults are to build a `.msi` for Windows, a `.dmg` for Mac, and both a `.deb` and `.rpm` for Linux.
These can be changed by editing the build section of the `package.json` file, see the
[electron-builder config docs](https://www.electron.build/configuration/configuration) for more information.

## Building multi platform using Docker

Electron-builder has a pre-configured Docker image that can help you build cross platform
images if you like Docker - again read [their docs](https://www.electron.build/multi-platform-build#build-electron-app-using-docker-on-a-local-machine).

This is very useful if you need to build for Windows on a Mac as the electron-builder invokes **wine** which is only 32-bit and so can't be run under Catalina.

## Developing and Testing - Running locally

While developing and testing you can just run your app locally by running

```bash
yarn start
```

from within the project folder.

The initial flow file is named `electronflow.json` along with it's credentials file
`electronflow_cred.json`. Just copy your existing flow in instead.

The default is to start on the dashboard page - as this is intended to be just an application - without the Node-RED editor exposed to the end user, but there are some simple flags to
to configure this within the package.json or at the top of main.js.

---

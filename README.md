<!-- DO NOT EDIT THIS FILE MANUALLY -->
<!-- Please read https://github.com/linuxserver/docker-chromium/blob/master/.github/CONTRIBUTING.md -->

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

## whats new

Enable target features whenever these env variables are present

```yaml
environment:
  - SOCAT=SOCAT
  - TUNED=TUNED
  - LESSLOG=LESSLOG
  - UA=safari
```

add SOCAT to enable remote debugging on 0.0.0.0:13011

add TUNED to add --user-agent and mute audio to save system resources

add LESSLOG to suppress chrome logs

add UA as useragent option: "safari|firefox|chrome|ipad|ioschrome"

fix `$CHROME_CLI`, now can pass '--var="strings"'

use `$CHROME_CLI_PLAIN` for no additional args

## Supported Architectures

We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://distribution.github.io/distribution/spec/manifest-v2-2/#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/).

Simply pulling `lscr.io/linuxserver/chromium:latest` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Available | Tag                     |
| :----------: | :-------: | ----------------------- |
|    x86-64    |    ✅     | amd64-\<version tag\>   |
|    arm64     |    ✅     | arm64v8-\<version tag\> |
|    armhf     |    ❌     |                         |

## Application Setup

The application can be accessed at:

- http://yourhost:3000/
- https://yourhost:3001/

### Options in all KasmVNC based GUI containers

This container is based on [Docker Baseimage KasmVNC](https://github.com/linuxserver/docker-baseimage-kasmvnc) which means there are additional environment variables and run configurations to enable or disable specific functionality.

#### Optional environment variables

|     Variable      | Description                                                                                                                                                                             |
| :---------------: | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|    CUSTOM_PORT    | Internal port the container listens on for http if it needs to be swapped from the default 3000.                                                                                        |
| CUSTOM_HTTPS_PORT | Internal port the container listens on for https if it needs to be swapped from the default 3001.                                                                                       |
|    CUSTOM_USER    | HTTP Basic auth username, abc is default.                                                                                                                                               |
|     PASSWORD      | HTTP Basic auth password, abc is default. If unset there will be no auth                                                                                                                |
|     SUBFOLDER     | Subfolder for the application if running a subfolder reverse proxy, need both slashes IE `/subfolder/`                                                                                  |
|       TITLE       | The page title displayed on the web browser, default "KasmVNC Client".                                                                                                                  |
|      FM_HOME      | This is the home directory (landing) for the file manager, default "/config".                                                                                                           |
|   START_DOCKER    | If set to false a container with privilege will not automatically start the DinD Docker setup.                                                                                          |
|      DRINODE      | If mounting in /dev/dri for [DRI3 GPU Acceleration](https://www.kasmweb.com/kasmvnc/docs/master/gpu_acceleration.html) allows you to specify the device to use IE `/dev/dri/renderD128` |
|      LC_ALL       | Set the Language for the container to run as IE `fr_FR.UTF-8` `ar_AE.UTF-8`                                                                                                             |
|     NO_DECOR      | If set the application will run without window borders for use as a PWA.                                                                                                                |
|      NO_FULL      | Do not autmatically fullscreen applications when using openbox.                                                                                                                         |

#### Optional run configurations

|                    Variable                    | Description                                                                                                                                                                                                                                              |
| :--------------------------------------------: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|                 `--privileged`                 | Will start a Docker in Docker (DinD) setup inside the container to use docker in an isolated environment. For increased performance mount the Docker directory inside the container to the host IE `-v /home/user/docker-data:/var/lib/docker`.          |
| `-v /var/run/docker.sock:/var/run/docker.sock` | Mount in the host level Docker socket to either interact with it via CLI or use Docker enabled applications.                                                                                                                                             |
|          `--device /dev/dri:/dev/dri`          | Mount a GPU into the container, this can be used in conjunction with the `DRINODE` environment variable to leverage a host video card for GPU accelerated appplications. Only **Open Source** drivers are supported IE (Intel,AMDGPU,Radeon,ATI,Nouveau) |

### Language Support - Internationalization

The environment variable `LC_ALL` can be used to start this image in a different language than English simply pass for example to launch the Desktop session in French `LC_ALL=fr_FR.UTF-8`. Some languages like Chinese, Japanese, or Korean will be missing fonts needed to render properly known as cjk fonts, but others may exist and not be installed. We only ensure fonts for Latin characters are present. Fonts can be installed with a mod on startup.

To install cjk fonts on startup as an example pass the environment variables:

```
-e DOCKER_MODS=linuxserver/mods:universal-package-install
-e INSTALL_PACKAGES=fonts-noto-cjk
-e LC_ALL=zh_CN.UTF-8
```

The web interface has the option for "IME Input Mode" in Settings which will allow non english characters to be used from a non en_US keyboard on the client. Once enabled it will perform the same as a local Linux installation set to your locale.

## Usage

To help you get started creating a container from this image you can either use docker-compose or the docker cli.

### docker-compose (recommended, [click here for more info](https://docs.linuxserver.io/general/docker-compose))

```yaml
---
services:
  chromium:
    image: lscr.io/linuxserver/chromium:latest
    container_name: chromium
    security_opt:
      - seccomp:unconfined #optional
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - CHROME_CLI=https://www.linuxserver.io/ #optional
    volumes:
      - /path/to/config:/config
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"
    restart: unless-stopped
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=chromium \
  --security-opt seccomp=unconfined `#optional` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CHROME_CLI=https://www.linuxserver.io/ `#optional` \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/chromium:latest
```

## Parameters

Containers are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

|                  Parameter                  | Function                                                                                                                                                               |
| :-----------------------------------------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|                  `-p 3000`                  | Chromium desktop gui.                                                                                                                                                  |
|                  `-p 3001`                  | HTTPS Chromium desktop gui.                                                                                                                                            |
|               `-e PUID=1000`                | for UserID - see below for explanation                                                                                                                                 |
|               `-e PGID=1000`                | for GroupID - see below for explanation                                                                                                                                |
|               `-e TZ=Etc/UTC`               | specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List).                                                         |
| `-e CHROME_CLI=https://www.linuxserver.io/` | Specify one or multiple Chromium CLI flags, this string will be passed to the application in full.                                                                     |
|                `-v /config`                 | Users home directory in the container, stores local files and settings                                                                                                 |
|                `--shm-size=`                | This is needed for any modern website to function like youtube.                                                                                                        |
|     `--security-opt seccomp=unconfined`     | For Docker Engine only, many modern gui apps need this to function on older hosts as syscalls are unknown to Docker. Chromium runs in no-sandbox test mode without it. |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

Will set the environment variable `MYVAR` based on the contents of the `/run/secrets/mysecretvariable` file.

## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

## User / Group Identifiers

When using volumes (`-v` flags), permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id your_user` as below:

```bash
id your_user
```

Example output:

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=chromium&query=%24.mods%5B%27chromium%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=chromium "view available mods for this container.") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "view available universal mods.")

We publish various [Docker Mods](https://github.com/linuxserver/docker-mods) to enable additional functionality within the containers. The list of Mods available for this image (if any) as well as universal mods that can be applied to any one of our images can be accessed via the dynamic badges above.

## Support Info

- Shell access whilst the container is running:

  ```bash
  docker exec -it chromium /bin/bash
  ```

- To monitor the logs of the container in realtime:

  ```bash
  docker logs -f chromium
  ```

- Container version number:

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' chromium
  ```

- Image version number:

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/chromium:latest
  ```

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (noted in the relevant readme.md), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Compose

- Update images:

  - All images:

    ```bash
    docker-compose pull
    ```

  - Single image:

    ```bash
    docker-compose pull chromium
    ```

- Update containers:

  - All containers:

    ```bash
    docker-compose up -d
    ```

  - Single container:

    ```bash
    docker-compose up -d chromium
    ```

- You can also remove the old dangling images:

  ```bash
  docker image prune
  ```

### Via Docker Run

- Update the image:

  ```bash
  docker pull lscr.io/linuxserver/chromium:latest
  ```

- Stop the running container:

  ```bash
  docker stop chromium
  ```

- Delete the container:

  ```bash
  docker rm chromium
  ```

- Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
- You can also remove the old dangling images:

  ```bash
  docker image prune
  ```

### Image Update Notifications - Diun (Docker Image Update Notifier)

**tip**: We recommend [Diun](https://crazymax.dev/diun/) for update notifications. Other tools that automatically update containers unattended are not recommended or supported.

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```bash
git clone https://github.com/linuxserver/docker-chromium.git
cd docker-chromium
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/chromium:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`

```bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

- **10.02.24:** - Update Readme with new env vars and ingest proper PWA icon.
- **08.01.24:** - Fix re-launch issue for chromium by purging temp files on launch.
- **29.12.23:** - Rebase to Debian Bookworm.
- **13.05.23:** - Rebase to Alpine 3.18.
- **01.04.23:** - Preserve arguments passed to Chromium and restructure to use wrapper.
- **18.03.23:** - Initial release.

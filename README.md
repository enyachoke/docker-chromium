# docker-chromium

Chromium inside docker (withi GUI).

Heavily inspired by this [Dockerfile](https://github.com/jessfraz/dockerfiles/tree/d871637d411bea624941c8732fe449c9d8a4b56e/chromium/Dockerfile) by Jessie Frazelle ([@jessfraz](https://twitter.com/jessfraz)).



## Features and changes compared to Jessie's Dockerfile

- Encapsulates Chromium web browser running on Linux.

- User interface is available on the host via mounted X11 socket.

- Runs Chromium as current (host) user. This way all the profile contents, cache and downloaded files are available on the host without file permission issues.

- Uses bridged network (Jessie used host).

- Generates random `/etc/machine-id` on every build. Generates random MAC address for the container on every run. They will not get us! (maybe).

- Runs in Ubuntu container (Jessie used Debian). No particular reason.


## Getting started

 - Build the container:

        ./build.sh

 - Run the container you've just built:

        ./run.sh

    You will see a new Chromium window spinning up.
    By default, this script will create and use a profile drirectory in `~/.config/docker-chromium-default` on host.
    Downloaded files will be available on host in `~/Downloads`, alongside your normal downloaded files.


## Customization

  - You can change the profile by adding its name as an argument to `run.sh`. For example

        ./run.sh "another-profile"

    will use `~/.config/docker-chromium-another-profile`. This way you can create multiple fully-isolated profiles.

  - You can change some of the settings in `run.sh`:
    ```bash
    # Profile name if none is specified on command line
    DEFAULT_PROFILE_NAME="default"

    # Where to put all Chromium profiles on the host
    PROFILE_ROOT="${HOME}/.config"

    # Where to put all Chromium caches on the host
    CACHE_ROOT="${HOME}/.cache"

    # Where to put downloaded files
    DOWNLOADS_DIR="${HOME}/Downloads"

    # Limit number of CPU cores available to Chromium (0 - automatic choice)
    N_CPUS=0

    # Limit memory available to Chromium
    MEMORY=2g

    # If you want Google APIs, you should provide your own info here
    GOOGLE_API_KEY="none"
    GOOGLE_DEFAULT_CLIENT_ID="none"
    GOOGLE_DEFAULT_CLIENT_SECRET="none"
    ```

  - [Seccomp security profiles](https://docs.docker.com/engine/security/seccomp) are in `seccomp.json`. Credits: taken as is from Jessie's dotfiles repo [here](https://github.com/jessfraz/dotfiles/blob/2e693ecfdb2fa395e8653a723de4f6f223b64134/etc/docker/seccomp/chrome.json).

## Known issues

 - `build.sh` detects username, group, UID and GID of the current host user and hardcodes this information on build time. So, in order to run the container as a different user next time, container has to be rebuilt.


## Notes

 - Because the user is hardcoded, the image you build is probably useless for other people (the run under different username, group, UID and GID). That's why I don't push the image on Docker Hub.

 - Hope there is (will be) a way to run as current user and to not hardcode anything


## See also:

 - https://github.com/jessfraz/dockerfiles

 - https://blog.jessfraz.com/post/docker-containers-on-the-desktop/#5-chrome
 
 - https://www.youtube.com/watch?v=cYsVvV1aVss


## Credits: 

  Heavily inspired by Jessie Frazelle's (@jessfraz) [dockerfiles](https://github.com/jessfraz/dockerfiles). I recommend you visit this repo.

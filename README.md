<a href="https://scan.coverity.com/projects/toxic-tox">
  <img alt="Coverity Scan Build Status"
       src="https://scan.coverity.com/projects/4975/badge.svg"/>
</a>

## About this fork

This fork ports Toxic to **macOS 14+ on Apple Silicon**. Plain `make` builds cleanly with zero warnings against the current SDK — no environment flags or `PKG_CONFIG_PATH` juggling required. End-to-end DHT bootstrap and friend connectivity verified on macOS 26.4.1 / arm64.

Headline changes vs. upstream:
- Homebrew prefix is auto-detected via `brew --prefix`, so the same build works on Intel (`/usr/local`) and Apple Silicon (`/opt/homebrew`).
- `osx_video.m` modernized: `AVCaptureDeviceDiscoverySession` replaces the deprecated `devicesWithMediaType:`, plus a real `AVCaptureDevice` over-release bug fixed.
- OpenAL includes on macOS switched from the deprecated system framework headers (`<OpenAL/al.h>`) to openal-soft (`<AL/al.h>`), which is what already gets linked.
- `_GNU_SOURCE` moved into the Linux branch of the Makefile (it's a no-op on macOS and was producing `-Wunused-macros` noise in every file that defined it).
- X11 and libnotify default to disabled on macOS. Video calls are **not** currently functional on macOS — capture is in place via AVFoundation, but the preview/display path still depends on X11 and the surrounding `__APPLE__` gating is inconsistent. See [INSTALL.md](/INSTALL.md) for details.

The rest of this README is from upstream and unchanged. macOS installation instructions are in [INSTALL.md](/INSTALL.md).

---

Toxic is a [Tox](https://tox.chat)-based peer-to-peer messenger that provides end-to-end encrypted communications without the use of centralized servers. It supports text messaging, file sharing, 1-on-1 voice and video calls, private audio conferences, public and private text group chats, and a few built-in games you can play with your friends. Toxic requires no registration or setup, and is ready to use out of the box. Its interface is highly customizable to suit your preferences.

[![Toxic Screenshot](https://i.imgur.com/TwYA8L0.png "Toxic Home Screen")](https://i.imgur.com/TwYA8L0.png)

## Installation
[See the install instructions](/INSTALL.md)

## Usage
As Toxic uses a text-based user interface, interacting with it involves a combination of navigation hotkeys and slash commands. For example, to navigate between open windows, use the `ctrl+o` and `ctrl+p` key combinations. Or to add a contact using their Tox address, use the command `/add {ADDRESS}` without the curly bracers. To see a full list of available commands and hotkeys, use the `/help` command or refer to the manual.

Toxic also has a number of run options. For example, if you want to use a different profile than the default, you can run toxic with the `--file my_profile.toxic` flag. Or to disable UDP/direct connections, use the `--force-tcp` flag. To see all available options, run toxic with the  `--help` flag, or refer to the manual.

## Settings
Running Toxic for the first time creates an empty file called toxic.conf in your home configuration directory (`~/.config/tox` for Linux users). You can use it to customize many aspects of the user interface, enable auto-logging, customize sound notifications, customize hotkeys, use custom names for your contacts, change the time format, and much more. You can view the example config file [here](misc/toxic.conf.example).

## Troubleshooting
If your default prefix is `/usr/local` and you receive the following:
```
error while loading shared libraries: libtoxcore.so.0: cannot open shared object file: No such file or directory
```
you can attempt to correct it by running `sudo ldconfig`. If that doesn't work, run:
```
echo '/usr/local/lib/' | sudo tee -a /etc/ld.so.conf.d/locallib.conf
sudo ldconfig
```


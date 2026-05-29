# Special options for macOS
# Assumes Homebrew. Works on both Intel (/usr/local) and Apple Silicon (/opt/homebrew).

BREW_PREFIX := $(shell brew --prefix 2>/dev/null)

# openal-soft is keg-only on Homebrew, so its .pc isn't on the default search path.
PKG_CONFIG := PKG_CONFIG_PATH=$(BREW_PREFIX)/opt/openal-soft/lib/pkgconfig:$$PKG_CONFIG_PATH pkg-config

# libnotify is Linux-only. X11 is used by the video-call preview/display
# windows in video_device.c, but `x11focus.h` is `#ifndef __APPLE__`-gated
# while `toxic.h` references X11_Focus whenever -DX11 is set -- so enabling
# X11 on macOS does not build cleanly. Treating both as off keeps macOS as
# an audio-only client.
DISABLE_X11 ?= 1
DISABLE_DESKTOP_NOTIFY ?= 1

# macOS ships ncurses (not ncursesw); swap the pkg-config name for a direct -l.
LIBS := $(filter-out ncursesw, $(LIBS))
LDFLAGS += -lncurses

OSX_LIBRARIES = -lobjc -lresolv
OSX_FRAMEWORKS = -framework Foundation -framework CoreFoundation -framework AVFoundation \
	-framework QuartzCore -framework CoreMedia
OSX_VIDEO = osx_video.m

LDFLAGS += $(OSX_LIBRARIES) $(OSX_FRAMEWORKS)
OBJ += osx_video.o

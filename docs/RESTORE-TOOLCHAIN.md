# The iOS restore toolchain

`tools/build_ios_restore.sh` cross-compiles everything the installer needs for
iOS arm64 into `build/ios/libhengerestore.a`.

What it builds, all from the vendored sources under `third_party/`:

- libplist, libimobiledevice-glue, libusbmuxd, libimobiledevice, libtatsu,
  libirecovery, usbmuxd and idevicerestore - the restore stack proper.
- mbedtls, only so libimobiledevice compiles: a restore never opens a TLS
  connection.
- libzip (via cmake).
- HengeVM's stand-ins for libusb and curl, plus the install glue.

Run it on a Mac with Xcode installed:

```sh
tools/build_ios_restore.sh       # iOS arm64, into build/ios
tools/build_ios_restore.sh mac   # the same sources for macOS, into build/mac-restore
```

The `mac` variant exists so the restore code that ships on iOS can be exercised
by tests running on the Mac.

Object files are rebuilt only when a source is newer, and libzip is built only
when its archive is missing, so re-running the script after a failure resumes
instead of starting over.

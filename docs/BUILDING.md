# Building Henge

Henge builds in three different ways, depending on what you need.

## Local engine build (macOS, no Xcode project)

The `Makefile` builds the emulator core, devices and test binaries with
plain clang — no Xcode required, only the Command Line Tools:

```bash
make            # test binaries + hengevm + hengevm-ref + hvsparse
make test       # build and run the full suite
make ios-lib    # static engine library linked into the iOS app
make help       # list the main targets
```

`hengevm-ref` is a Mac-only reference tool that runs the same guest on
Hypervisor.framework, useful to compare behaviour against the JIT.
Metal-based devices need the macOS frameworks listed in the Makefile;
`pvg_mac.o` targets macOS 15.2+ (ParavirtualizedGraphics.framework).

## Unsigned IPA via Bitrise

`bitrise.yml` + `ci/build-bitrise.sh` produce an ad-hoc-signed IPA on a
Bitrise macOS/Xcode stack; SideStore or AltStore re-signs it on device.
The script expects `BITRISE_SOURCE_DIR` and a `Husk` checkout next to the
Henge one. The push trigger in `bitrise.yml` points at a retired fix
branch, so builds start manually from the Bitrise dashboard and no Bitrise
minutes are spent on ordinary pushes.

## Rebuilding StikJIT for high JIT addresses

`ci/build-stikjit.sh` rebuilds StikJIT 1.9.0 (pinned to commit
`32287268`) with `ci/stikjit-high-address.patch` applied: the stock
nine-digit packet format truncates JIT mappings above `0xfffffffff` on
iPads. See `docs/PATCHES.md`.

## CI diagnostics

`.github/workflows/build-henge.yml` is a manual (workflow_dispatch)
diagnostic build pinned to exact upstream Henge/Husk revisions, on an
`xcode-27` runner. It never runs on push.

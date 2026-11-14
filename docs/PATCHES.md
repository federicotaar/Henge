# Patches carried by this fork

Patches this fork applies on top of other projects at build time, and why.

## ci/stikjit-high-address.patch — StikJIT full-width debugserver addresses

- **Project**: StikJIT 1.9.0, pinned to commit
  `32287268fa5824f9edce4cb359f5833ce0cf7b00` (see `ci/build-stikjit.sh`).
- **File touched**: `Sources/ScriptRunner.swift`.
- **Problem**: the stock debugserver packet format reserves nine hex digits
  for a JIT page address. On iPads the JIT mappings can sit above
  `0xfffffffff`, so the address gets truncated and the mapping fails.
- **Fix**: widen the field to 16 hex digits
  (`jitPageCommandLength = 2 + 16 + 8` instead of `19`) and adjust the
  command construction accordingly.

Apply with `ci/build-stikjit.sh <path-to-StikJIT-checkout>`.

# Regenerating the AltStore/SideStore source

`tools/update-source.py` rewrites `repo.json` at the repository root from the
GitHub releases, so the Henge source people add in AltStore or SideStore
always points at the current release:

```sh
python3 tools/update-source.py
```

Behaviour worth knowing (all covered by the script's own comments and the
2026-11-14 fixes):

- `repo.json` is written atomically (temp file, then rename), so a failed run
  never leaves a half-written source behind.
- Screenshot file names are quoted in their URLs, and a missing
  `Screenshots/` folder produces a warning instead of an abort.
- The download count and release metadata come straight from the GitHub API
  at run time, so run it only after the release it should advertise exists.

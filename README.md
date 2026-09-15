# Prüfstein Homebrew tap

The [Prüfstein](https://github.com/explore-de/pruefstein) compliance agent, for macOS.

```bash
brew tap explore-de/pruefstein
brew trust explore-de/pruefstein
brew install pruefstein-agent
```

`brew trust` is not optional: since Homebrew 7 a formula from a third-party
tap will not load until you have said you trust the tap it comes from, and the
error it gives instead is easy to read as the tap being broken. `brew untrust
explore-de/pruefstein` takes it back.

The formula installs a prebuilt GraalVM native binary — there is no JVM to
install and nothing to compile. Apple silicon and Intel are both covered; the
archives come from the [releases](https://github.com/explore-de/pruefstein/releases)
of the main repository, built by `agent-release.yml` there.

## Updating the formula

A release of the agent publishes an archive and a checksum per architecture.
To point the formula at a new one:

```bash
brew bump-formula-pr --version=1.0.1 explore-de/pruefstein/pruefstein-agent
```

which rewrites both URLs and both checksums. `brew livecheck pruefstein-agent`
reports whether there is a newer release to move to.

## What the agent does

It runs your ISO 27001 checks locally through [osquery](https://osquery.io/),
shows you every result, and reports nothing until you say so. osquery is not
installed by this formula; `pruefstein-agent run` offers to install it the
first time it needs it.

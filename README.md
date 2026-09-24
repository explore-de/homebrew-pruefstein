# Prüfstein Homebrew tap

The [Prüfstein](https://github.com/explore-de/pruefstein) compliance agent, for macOS.

```bash
brew install explore-de/pruefstein/pruefstein-agent
```

One command. Naming the tap in full is what makes that work — Homebrew taps on
your behalf, and installing this way asks for nothing else.

Tapping separately is the other way round:

```bash
brew tap explore-de/pruefstein
brew trust explore-de/pruefstein
brew install pruefstein-agent
```

The `brew trust` line is needed on that path and only on that path: since
Homebrew 7 a formula referred to by its bare name will not load from a
third-party tap until the tap is trusted, and the refusal reads like the tap is
broken rather than like a step being missing. `brew untrust
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
shows you every result, and reports nothing until you say so. The formula
depends on the osquery cask, so installing the agent installs osquery too.

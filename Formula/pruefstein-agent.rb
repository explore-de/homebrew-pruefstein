# The agent ships as a GraalVM native image, so there is nothing to compile
# here and nothing to bottle: one prebuilt binary per architecture, unpacked
# from the release its version names. Built by agent-release.yml in
# explore-de/pruefstein, which is also where the checksums below come from.
class PruefsteinAgent < Formula
  desc "Check this Mac against your ISO 27001 controls, and report only if you say so"
  homepage "https://github.com/explore-de/pruefstein"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Written out rather than interpolated from a `version` line, so that
  # `brew bump-formula-pr --version=…` can rewrite the URLs and both
  # checksums on its own. Homebrew reads the version back out of the filename.
  on_macos do
    on_arm do
      url "https://github.com/explore-de/pruefstein/releases/download/v1.0.4/pruefstein-agent-1.0.4-darwin-arm64.tar.gz"
      sha256 "a6469b767cdee580db0cf948354ba401c80d3273c0e7fe9af5e40c8fe973eaa6"
    end

    on_intel do
      url "https://github.com/explore-de/pruefstein/releases/download/v1.0.4/pruefstein-agent-1.0.4-darwin-amd64.tar.gz"
      sha256 "ee0ea278be3b4190f1dea39975b02992c8cf9bea9a1b2c0eb2b2a81929dee2bd"
    end
  end

  def install
    bin.install "pruefstein-agent"
  end

  def caveats
    <<~EOS
      The checks run through osquery, which is not installed with this formula:

        brew install --cask osquery

      `pruefstein-agent run` offers to do that for you the first time it needs
      it, and asks before it does — the same way it asks before reporting
      anything.

      Point the agent at your server once; it remembers:

        pruefstein-agent login --server https://pruefstein.example.com
        pruefstein-agent run
    EOS
  end

  # Nothing here touches the network or the machine's configuration: the point
  # is that the unpacked binary starts and still knows its own interface.
  test do
    # The binary that was unpacked is the one the URL promised.
    assert_match version.to_s, shell_output("#{bin}/pruefstein-agent --version")
    assert_match "compliance agent", shell_output("#{bin}/pruefstein-agent --help")
    assert_match "login", shell_output("#{bin}/pruefstein-agent --help")
    # --server is the one flag somebody has to be told about, and the one a
    # broken repackaging would most plausibly lose.
    assert_match "--server", shell_output("#{bin}/pruefstein-agent login --help")
  end
end

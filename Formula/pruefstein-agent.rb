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

  # Every check shells out to osqueryi, but a formula cannot depend on a cask:
  # Homebrew rejects `depends_on cask:` outright. The agent names
  # `brew install --cask osquery` itself when it finds osqueryi missing.

  # Written out rather than interpolated from a `version` line, so that
  # `brew bump-formula-pr --version=…` can rewrite the URLs and both
  # checksums on its own. Homebrew reads the version back out of the filename.
  on_macos do
    on_arm do
      url "https://github.com/explore-de/pruefstein/releases/download/v1.0.8/pruefstein-agent-1.0.8-darwin-arm64.tar.gz"
      sha256 "af3ea3c5a04823ab65e58bfe320b63a5feaecd7cce07c953a9d92237feabb466"
    end

    on_intel do
      url "https://github.com/explore-de/pruefstein/releases/download/v1.0.8/pruefstein-agent-1.0.8-darwin-amd64.tar.gz"
      sha256 "e6b548699e2a9a6673cd9cbe481910fe35a1bd44b453e58c3ddcc6a7e04f59a3"
    end
  end

  def install
    bin.install "pruefstein-agent"
  end

  # No caveats on purpose. They print on every install and on every `brew
  # info`, so they are for what nothing else can say — and `login --help`
  # documents --server down to the example URL. Repeating that here is noise
  # that a reader has to scroll past forever to learn it twice.

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

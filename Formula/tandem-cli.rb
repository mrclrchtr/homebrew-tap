class TandemCli < Formula
  desc "Git-aware ticket coordination system for AI agents in a monorepo"
  homepage "https://github.com/mrclrchtr/tandem"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.8.0/tandem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b8890ab45359f2ac9f957c8b0b153d44c3549e35ad289392caf11d306144ff29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.8.0/tandem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f8d0fa4e172c40f2333674fde501f48ecff9378025e4dbec131f43e88fb41572"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.8.0/tandem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a1285230baa43142b5bd80389a4a81021d79c42a852634c4985877a1135bbcf2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.8.0/tandem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "513630f2f8b8b70fd6106eba20baef5a717d90668a04a7761aac620007939c00"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tndm" if OS.mac? && Hardware::CPU.arm?
    bin.install "tndm" if OS.mac? && Hardware::CPU.intel?
    bin.install "tndm" if OS.linux? && Hardware::CPU.arm?
    bin.install "tndm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

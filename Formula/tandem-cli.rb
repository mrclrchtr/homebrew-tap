class TandemCli < Formula
  desc "Git-aware ticket coordination system for AI agents in a monorepo"
  homepage "https://github.com/mrclrchtr/tandem"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.6.1/tandem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f15b0a530d0cd9afea5d49eb15cdb062a32e2d5f3815f9f58c0edc2a99d1a2c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.6.1/tandem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a1dd6ee503957849d591ac4262c2680166c07a5dcf1631df2cfcfbe10b820ae2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.6.1/tandem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "612b098aa02567d1a08266a274bf5f399c2cec6368b7df32c00d5f9dd804559a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.6.1/tandem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "987afdfef9f047197f81e4f4c11d7b7927722ae1a7b41a0e6bf515cda86af2d4"
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

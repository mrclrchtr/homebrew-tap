class TandemCli < Formula
  desc "Git-aware ticket coordination system for AI agents in a monorepo"
  homepage "https://github.com/mrclrchtr/tandem"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.13.0/tandem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6a5ef266bad188b5f399b332e61fdb324cc87a9aa5095c0843f9a0eb9bcf9e47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.13.0/tandem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0eaf75001d82f37ebf16582d537381ab77bd8fac60c57261548e125abef3d13f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.13.0/tandem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b54c67bf98debe19e8d7a24eddea67e522525a4bdb5ca5f54fd2e102283d912"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.13.0/tandem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9599159098d9792c77bab39cf386e3ef3063815f9c86ed6ccd5f823af6064c3c"
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

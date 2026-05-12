class TandemCli < Formula
  desc "Git-aware ticket coordination system for AI agents in a monorepo"
  homepage "https://github.com/mrclrchtr/tandem"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.7.0/tandem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d99bfdeb41db2668d9a08137d7112b3e5c9da6c80922ee6980d703336622596d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.7.0/tandem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2f33b4e1467cf81eb1d794df5fa31dde8652a604ae2c14c308bb64cfeefd8080"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.7.0/tandem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "19889c243cfdd5874e7ee3d17c61af0fd6467477206d0f82899a219231260c44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.7.0/tandem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0193fcd044e90373b411a12db263e16874a5e307f0d652993b05cb2b80259b37"
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

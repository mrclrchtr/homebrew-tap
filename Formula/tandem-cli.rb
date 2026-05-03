class TandemCli < Formula
  desc "Git-aware ticket coordination system for AI agents in a monorepo"
  homepage "https://github.com/mrclrchtr/tandem"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.5.0/tandem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ba3560519c48d8bf4f66868da94af8ba633a0d831897c68288630b4e33911e39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.5.0/tandem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "830ef9b3e75b334329f26d837c62975ed8bd5510d7452a3fd48465e73d17bc65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.5.0/tandem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3d4454c074c85e630b236205f812f30dfa28f973ee0ad6f6c2b0903f2b8ff99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.5.0/tandem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "36141aa32e95c9ad557ced44ad7a46404bdd2494de0ebd56f5cf124d1374e450"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tndm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tndm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tndm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tndm"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

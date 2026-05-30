class TandemCli < Formula
  desc "Git-aware ticket coordination system for AI agents in a monorepo"
  homepage "https://github.com/mrclrchtr/tandem"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.15.0/tandem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b3dabacc6404984eaecda2076a0e9715a64a34b0f8386064585e94e0c73de1a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.15.0/tandem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2c244730b3793975f728ed065689beae301ebcbea45cefc1fedcfd2fc3e97ca5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.15.0/tandem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "04633a7769791107a3e8ce6750175fa9e7cca2e4f11d896bf363e9d75b45b906"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mrclrchtr/tandem/releases/download/v0.15.0/tandem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c89eb677253d77f26276f4e88fd12f04144c0bb3e9530b5a3558ad13bf574c78"
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

class Gmcloser < Formula
  homepage "https://sourceforge.net/projects/gmcloser/"
  url "https://downloads.sourceforge.net/project/gmcloser/GMcloser-1.6.tar.gz"
  sha256 "fc7d8de8e4ef67bfc00be7f4a60542ab65e6cea182ae9dc346b07da7f02140e7"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, high_sierra:  "8a3ee8e69ec9e5959fe387fc567f63aa690ae61e687dd5001ebe85d16b8c8a08"
    sha256 cellar: :any_skip_relocation, sierra:       "8a3ee8e69ec9e5959fe387fc567f63aa690ae61e687dd5001ebe85d16b8c8a08"
    sha256 cellar: :any_skip_relocation, el_capitan:   "28eb73d81ea789cbbd6c9f9c8c3ab5d16634982c162a6428e19f516da43800fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8598681e6924ccf8e4ab01681d702395ee2166e975b20bac4e6f61a623f58188"
  end

  def install
    doc.install "Manual_GMcloser.pdf"
    libexec.install Dir["*"]
    (bin/"gmcloser").write <<~EOS
      #!/bin/sh
      set -eu
      exec #{libexec}/gmcloser "$@"
    EOS
  end

  test do
    system "#{bin}/gmcloser", "--help"
  end
end

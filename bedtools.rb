class Bedtools < Formula
  desc "bedtools: A powerful toolset for genome arithmetic"
  homepage "https://github.com/arq5x/bedtools2"
  # doi "10.1093/bioinformatics/btq033"
  # tag "bioinformatics"

  url "https://github.com/arq5x/bedtools2/archive/v2.26.0.tar.gz"
  sha256 "15db784f60a11b104ccbc9f440282e5780e0522b8d55d359a8318a6b61897977"

  head "https://github.com/arq5x/bedtools2.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "80327fefdeb4e62c8c8ca63a952280770d18ee13dcda3cdbaa7d665ac22fdf3d" => :el_capitan
    sha256 "ac21a1867ba547bac8f920289e26184115a0b0171b4e3ff3d7aada4fee5c8006" => :yosemite
    sha256 "c11b62597d927e97a3e66875519cc1f28f39afb31fd68a423498282bb357583e" => :mavericks
    sha256 "3ed7fdb7f2de01c13d6ff6bba76852667fd65d570e5ed1d68b83b7d96b51e851" => :x86_64_linux
  end

  def install
    system "make"
    prefix.install "bin"
    doc.install %w[README.md RELEASE_HISTORY]
  end

  test do
    system "#{bin}/bedtools", "--version"
  end
end

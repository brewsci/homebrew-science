class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  # doi "10.1093/bioinformatics/bts277"
  # tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.23.tar.gz"
  sha256 "61cf6895782f3184f1853f144357e0d1a45e8e42821853ba9562bed0f4509144"

  head "https://github.com/bedops/bedops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f5eecdff1dfe87183591e7779757cb4197844e15ddcd3258ae3d2d345cf67bb" => :sierra
    sha256 "91210cc1ef59967ac7b40df52cc70604a489c0a3ddf51bed3255e934dc39ba95" => :el_capitan
    sha256 "fabfadbc8612ae9403f72ed53fb22bd62368f836de44f045ab0e8c32add44fe3" => :yosemite
    sha256 "90f52a4ef4d44e27836df01fc74e0062f7a03105ac29d90ded8adc459f509e04" => :x86_64_linux
  end

  env :std

  fails_with :gcc do
    build 5666
    cause "BEDOPS toolkit requires a C++11 compliant compiler"
  end

  def install
    ENV.O3
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")
    system "make"
    system "make", "install"
    bin.install Dir["bin/*"]
    doc.install %w[LICENSE README.md]
  end

  test do
    system "#{bin}/bedops", "--version"
  end
end

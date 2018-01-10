class Repeatscout < Formula
  homepage "https://bix.ucsd.edu/repeatscout/"
  # doi "10.1093/bioinformatics/bti1018"
  # tag "bioinformatics"

  url "https://bix.ucsd.edu/repeatscout/RepeatScout-1.0.5.tar.gz"
  sha256 "bda6f782382f2b7dcb6a004b7da586d5046b3c12429b158e24787be62de6199c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b03af9a3be3be79b556401d5270a8216c06aa54cd5dec861068ab6e2acd06454" => :sierra
    sha256 "46e0c47129bc7449c083fd6588e2b0db6caa4f4e179f33fe42ffb758a9638543" => :el_capitan
    sha256 "bd9704196baabb1e7abee5c227a209e49f5a155fe47b5395a2db77e63f78708c" => :yosemite
    sha256 "e5818bb9b5762295c60dc5411ff3f97e749d9a0f3229e9f079d7d0b1c2e6c671" => :x86_64_linux
  end

  depends_on "trf" => :optional

  def install
    system "make"
    prefix.rmdir
    system *%W[make install INSTDIR=#{prefix}]
    bin.install_symlink "../RepeatScout"
  end

  test do
    system "#{bin}/RepeatScout 2>&1 |grep RepeatScout"
  end
end

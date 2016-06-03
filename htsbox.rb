class Htsbox < Formula
  desc "Experimental tools on top of htslib"
  homepage "https://github.com/lh3/htsbox"
  # tag "bioinformatics"

  url "https://github.com/lh3/htsbox/archive/r312.tar.gz"
  version "r312"
  sha256 "18956deaf1d163a01f36e7849aba8ff01e9d883bd4792f870debdce53d0b665e"

  head "https://github.com/lh3/htsbox.git", :branch => "lite"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a94dbafcf6d0c44a1e7527a027b9ac0422cc5d45d796cc7e804c91d3f18899f" => :el_capitan
    sha256 "e108883fec20ea411cd33761c1fe3aa7f91689b99b3a29ca78820ba60aed78e0" => :yosemite
    sha256 "a900b7615452ca156d58a4387a4abc23dc680b68926121fde9dc86ef74859c9d" => :mavericks
    sha256 "148a01cec3fcfacaf6b519bd102552af2be0023c2c98845678e610f0a23cf84d" => :x86_64_linux
  end

  depends_on "htslib"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "htsbox"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/htsbox 2>&1", 1)
  end
end

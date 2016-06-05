class Nanopolish < Formula
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  # doi "10.1038/nmeth.3444"
  # tag "bioinformatics"

  url "https://github.com/jts/nanopolish.git",
    :tag => "v0.4.0",
    :revision => "28bcaa3ea9de8394441c0ceac5b96cf409015a10"
  head "https://github.com/jts/nanopolish.git"

  bottle do
    cellar :any
    sha256 "1c549b3531199a61f5d3614a81249c9ddc7971a4b82db3f32047283e5f44da78" => :el_capitan
    sha256 "7ece6dfcee6cbce122e77df08d45839a8ecc5fc8fd6fa7e69ea4c6adc4aa5d27" => :yosemite
    sha256 "80756bb5bccf558984a0b8153a687e07f97c845a13cc2d8bc8d890698895f76d" => :mavericks
    sha256 "ecf4857a09dce1ccd7e7a658596e61644b515ceeb9947819c028cc78341d47db" => :x86_64_linux
  end

  needs :cxx11
  needs :openmp

  depends_on "hdf5"

  def install
    system "make", "HDF5=#{Formula["hdf5"].opt_prefix}"

    prefix.install "scripts", "nanopolish"
    bin.install_symlink "../nanopolish"
    doc.install "LICENSE", "README.md"
  end

  test do
    `#{bin}/nanopolish consensus --version`.include?(version.to_s)
  end
end

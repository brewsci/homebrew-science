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
    sha256 "dab598f322332ce9ba53fbeb5931445dc4d831fd4407d8be89d95ef62d0e3f95" => :el_capitan
    sha256 "0653aa2cf44c4cd880d101f002dba7ccd2fb73fec4b0f4619df983deaeb32d44" => :yosemite
    sha256 "a701637042df3b4ec2d8f5b9f439e373d2cb6f9797e2c548b51a29faca10c915" => :mavericks
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

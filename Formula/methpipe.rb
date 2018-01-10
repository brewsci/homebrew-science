class Methpipe < Formula
  homepage "http://smithlabresearch.org/software/methpipe/"
  url "http://smithlabresearch.org/downloads/methpipe-3.4.3.tar.bz2"
  sha256 "56716370211a7b45b0a3a2994afb64d64c15dd362028f9ecd8a0551a6e6d65c3"
  head "https://github.com/smithlabcode/methpipe.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "642416ae7b961600aebe2c6a3d335df8dc15b0c010fd0452a4f84d7f22ec6978" => :sierra
    sha256 "ba868cf1ced91981626ebd4b5dfd99d8ed51c633a71289a4bb6f64c80afdb563" => :el_capitan
    sha256 "7fc5cc9b9bd26c2f7c2d9275cd940722b701275088a4c4791a5f0d71f4d6d88e" => :yosemite
    sha256 "5c44012ac765d23a6ac048fb45d584a36b0d0f4bc9bd511c0f5426c28093ea11" => :x86_64_linux
  end

  depends_on "gsl"

  def install
    system "make", "all"
    system "make", "install"
    prefix.install "bin"
  end

  test do
    system "#{bin}/symmetric-cpgs", "-about"
  end
end

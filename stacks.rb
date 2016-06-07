class Stacks < Formula
  desc "Pipeline for building loci from short-read sequences"
  homepage "http://creskolab.uoregon.edu/stacks/"
  # doi "10.1111/mec.12354"
  # tag "bioinformatics

  url "http://creskolab.uoregon.edu/stacks/source/stacks-1.37.tar.gz"
  sha256 "11be4417504e4f14d64d0c022e1a9c7ced822ce529f251defbd1b83b34fc288d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d091ee248b6b9c6c7b1373af824c1a2cf16830c64960463bfaaf8052b2b7b37a" => :el_capitan
    sha256 "b266a452669b9913a95c1df9663fbd850a62199f5a0e275d6caa6f59d82e7fb4" => :yosemite
    sha256 "2529637a4469483d6799290cde83d7415859db21a0f9a487b1ddc5d8c18cb4c8" => :mavericks
    sha256 "b6bba95f5d975d17490bef25e88d52f709bdff5278b92401354025cef1cf4e86" => :x86_64_linux
  end

  depends_on "htslib"

  if MacOS.version < :mavericks
    depends_on "google-sparsehash" => [:recommended, "c++11"]
  else
    depends_on "google-sparsehash" => :recommended
  end

  needs :cxx11

  def install
    ENV.libcxx

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-sparsehash" if build.with? "google-sparsehash"

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      For instructions on setting up the web interface:
          #{prefix}/README

      The PHP and MySQL scripts have been installed to:
          #{share}
    EOS
  end

  test do
    system "#{bin}/ustacks", "--version"
  end
end

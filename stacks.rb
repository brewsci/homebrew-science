class Stacks < Formula
  homepage "http://creskolab.uoregon.edu/stacks/"
  #doi "10.1111/mec.12354"
  #tag "bioinformatics

  url "http://creskolab.uoregon.edu/stacks/source/stacks-1.28.tar.gz"
  sha256 "1ffd9357e29e09fd8bdc85a03e13b2c615ef6b5a9394bcef031386da0e155b65"

  bottle do
    sha256 "57915a5d94db9e595426938c4378dd9d491cd8f062eda3b546db6c94783d139e" => :yosemite
    sha256 "08838646eec18d586f3d504b25e4980b5fb14ddbc568ad30498f8d51b6c704b4" => :mavericks
  end

  depends_on "google-sparsehash" => :recommended
  depends_on "htslib"

  needs :cxx11

  def install
    # OpenMP doesn't yet work on OS X with Apple-provided compilers.
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

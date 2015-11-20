class FastqTools < Formula
  homepage "http://homes.cs.washington.edu/~dcjones/fastq-tools/"
  #tag "bioinformatics"

  url "https://homes.cs.washington.edu/~dcjones/fastq-tools/fastq-tools-0.7.tar.gz"
  sha1 "75540e322543041c9005f248b2b9bcdba5be728a"

  bottle do
    cellar :any
    sha256 "e86ffa61e35cbd3b14228a6183b3c472323c6752d47c2586cd41516a6f5c9d6e" => :yosemite
    sha256 "ee21d34a811b294d11b809bdd22abbdf5cb5b0c7ed855d74592565f9c9c40c04" => :mavericks
    sha256 "b9f6d5213d969eafadfd1d82171a296c145a67afc70f758445e919a2ea31e56a" => :mountain_lion
  end

  depends_on "pcre" => :build

  def install
    system "./configure",
      "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fastq-grep", "--version"
  end
end

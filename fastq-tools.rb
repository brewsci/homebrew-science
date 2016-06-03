class FastqTools < Formula
  homepage "http://homes.cs.washington.edu/~dcjones/fastq-tools/"
  # tag "bioinformatics"

  url "https://homes.cs.washington.edu/~dcjones/fastq-tools/fastq-tools-0.7.tar.gz"
  sha256 "4088a47123b4f8d8eadd042cd04e459646789f4de8c9e3992e9236aa8ecbaefe"

  bottle do
    cellar :any
    sha256 "e86ffa61e35cbd3b14228a6183b3c472323c6752d47c2586cd41516a6f5c9d6e" => :yosemite
    sha256 "ee21d34a811b294d11b809bdd22abbdf5cb5b0c7ed855d74592565f9c9c40c04" => :mavericks
    sha256 "b9f6d5213d969eafadfd1d82171a296c145a67afc70f758445e919a2ea31e56a" => :mountain_lion
    sha256 "1674cbecb09313439c129349cbd0920a77c12aa36934b47a5709c91e3f457041" => :x86_64_linux
  end

  depends_on "pcre"

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

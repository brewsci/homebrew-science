class Adapterremoval < Formula
  desc "Adapter trimming, consensus, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/v2.2.2.tar.gz"
  sha256 "99832546428a1e9463a565fa726844a0559828bda9428b2b51ef6b3558079b67"
  # doi "10.1186/s13104-016-1900-2"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "b1aae1b89e128b507e119d4ab94844a64e2e817c9b8dc62a50a6b89466d9fd33" => :sierra
    sha256 "8f26751f1ac7176b73270270bfcf6ca917591c64e6bfd722017ed89664165b08" => :el_capitan
    sha256 "939e933e8d3cfd8b733eef9b0baf515813c6065d7b994613270895503a66a385" => :yosemite
    sha256 "098194dfec4b0dd2436186b2405e08d43c55c8ca56bdee22a53341e359eb9fa7" => :x86_64_linux
  end

  depends_on "bzip2" => :recommended
  depends_on "zlib" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/AdapterRemoval", "--bzip2", \
        "--file1", "#{pkgshare}/examples/reads_1.fq", \
        "--file2", "#{pkgshare}/examples/reads_2.fq", \
        "--basename", "#{testpath}/output"
  end
end

class Adapterremoval < Formula
  desc "adapter trimming, consensus, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/v2.2.0.tar.gz"
  sha256 "491275d0b65cf7f44818e841d24499e897c3aaf637406144f9e6367ddd2a5177"
  # doi "10.1186/s13104-016-1900-2"
  # tag "bioinformatics"

  depends_on "homebrew/dupes/bzip2" => :recommended
  depends_on "homebrew/dupes/zlib" => :recommended

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

class Adapterremoval < Formula
  desc "adapter trimming, consensus, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/v2.2.1a.tar.gz"
  version "2.2.1a"
  sha256 "4784c830b2283ea910e6ff488b3791c96a8139101191112166a0608d5c945f7d"
  # doi "10.1186/s13104-016-1900-2"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "df8e67f8518c8bf15ffe93b644b5fd77dfadfd686d7cdc9eb096ca88176cbc2f" => :sierra
    sha256 "710e9ecdabfff6400c2059415505a77aea67eb15076ddadf63f76b54e7505a26" => :el_capitan
    sha256 "71c311b9d04c31e82a71a4fc4b4b748afd3ddb06881cbef4ad3e5cd3bd19410d" => :yosemite
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

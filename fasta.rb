class Fasta < Formula
  homepage "http://faculty.virginia.edu/wrpearson/fasta/"
  # doi "10.1016/0076-6879(90)83007-V"
  # tag "bioinformatics"

  url "http://faculty.virginia.edu/wrpearson/fasta/fasta36/fasta-36.3.8.tar.gz"
  sha256 "e235458afd16591bbcd5b89b639497e20346841091440a2445593318510a2262"

  bottle do
    cellar :any
    sha256 "3fb1552fa6887d73ceaab44f6632697c5a4130bd29b3826236f34fd1aa5f4f6f" => :yosemite
    sha256 "887a5ed9bf87b815098738f680717741b55b544b68d7fcced77653a166b61b74" => :mavericks
    sha256 "6b237170e06c877f6ccd486104b7f8505b927b9ab8d62e7193ff778e96ace18e" => :mountain_lion
    sha256 "cbf9e27307f4a0f88f5f7557b326039495c20b3e692c7a3ee4d605ea77f78f52" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    mkdir "bin"
    cd "src" do
      system "make", "-f",
        if OS.mac?
          "../make/Makefile.os_x86_64"
        elsif OS.linux?
          "../make/Makefile.linux64_sse2"
        else
          raise "Unknown operating system"
        end
    end
    rm "bin/README"
    bin.install Dir["bin/*"]
    doc.install Dir["doc/*"]
  end

  test do
    system "#{bin}/fasta36"
  end
end

class Fasta < Formula
  homepage "http://faculty.virginia.edu/wrpearson/fasta/"
  # doi "10.1016/0076-6879(90)83007-V"
  # tag "bioinformatics"

  url "http://faculty.virginia.edu/wrpearson/fasta/fasta36/fasta-36.3.8.tar.gz"
  sha256 "e235458afd16591bbcd5b89b639497e20346841091440a2445593318510a2262"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cba2aee49586bdeb6121e2fe933329b938d927b823bbca4dd58ce45e7c2b379" => :high_sierra
    sha256 "a892fdacc1b440df741f6790de590430dac7a2444c04c49e9d9104b29ddf2a40" => :sierra
    sha256 "3e0a3877f9e711fc6ad856df2f94ed209e4d9732dec982ac02a169c6b46bf6d3" => :el_capitan
    sha256 "7ac967feb0b5cc8b59a2fe3cbc7786e9a2d5925af50f7dd8db36cd16abf08032" => :x86_64_linux
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

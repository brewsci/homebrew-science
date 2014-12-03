require "formula"

class Fasta < Formula
  homepage "http://faculty.virginia.edu/wrpearson/fasta/"
  #doi "10.1016/0076-6879(90)83007-V"
  #tag "bioinformatics"

  url "http://faculty.virginia.edu/wrpearson/fasta/fasta36/fasta-36.3.7.tar.gz"
  sha1 "184acbac526ebdb3cad0009d87bd2a68b4756a03"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "752acd5b851cb56d4d42468a3e0257aa8771a5a3" => :yosemite
    sha1 "ef93a8f05f798a36f04cdd5813668afab612bbff" => :mavericks
    sha1 "00b921910231d3112263e2fb9749d7e8b4fee7fa" => :mountain_lion
  end

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
    bin.install Dir["bin/*"]
    doc.install Dir["doc/*"]
  end

  test do
    system "#{bin}/fasta36"
  end
end

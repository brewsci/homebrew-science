class InterViews < Formula
  homepage "http://www.neuron.yale.edu/neuron/"
  url "http://www.neuron.yale.edu/ftp/neuron/versions/v7.4/iv-19.tar.gz"
  sha256 "3cb76ad00ebf4282d4c586540f54624fef7ecf8cd3fa2e6b3075d8fdacdc42e0"

  head "http://www.neuron.yale.edu/hg/neuron/iv", :using => :hg

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 1
    sha256 "b567187f0b58e0304e1bf3c9a401ed6961fd0644bfbc7482c3bd1a59f64ee9bb" => :yosemite
    sha256 "7a2bdc42a76d30d90735424035ae23c9713021f8a3dcb77d4094c5fd06ba194d" => :mavericks
    sha256 "947175f2ffe311d7fbee454fb2cf8b564cb9e2529d381b4452ace099722f77f7" => :mountain_lion
  end

  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}", "--exec-prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    assert File.exist?("#{bin}/iclass") && File.executable?("#{bin}/iclass")
    assert File.exist?("#{bin}/idemo") && File.executable?("#{bin}/idemo")
    assert File.exist?("#{bin}/idraw") && File.executable?("#{bin}/idraw")
  end
end

class InterViews < Formula
  homepage "https://www.neuron.yale.edu/neuron/"
  url "https://www.neuron.yale.edu/ftp/neuron/versions/v7.4/iv-19.tar.gz"
  sha256 "3cb76ad00ebf4282d4c586540f54624fef7ecf8cd3fa2e6b3075d8fdacdc42e0"

  head "http://www.neuron.yale.edu/hg/neuron/iv", :using => :hg

  bottle do
    sha256 "450c67bb59269255d149bc07debe9b76e829e4715063bd972a4b73cdbcdb8d1e" => :yosemite
    sha256 "bdb29d9c03e11784b04b22463c581cbe5a01d63f8125800acdd76df74e85630f" => :mavericks
    sha256 "9df2b7d27735b76e3a88e01718a430ad29118f167a57745ba3288d6a6a6fd2f4" => :mountain_lion
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

class InterViews < Formula
  homepage "http://www.neuron.yale.edu/neuron/"
  url "http://www.neuron.yale.edu/ftp/neuron/versions/v7.3/iv-18.tar.gz"
  sha256 "a875692a20211e0856e9e283ab9ef5da022b4d49853aa7f2f734104f399e7af1"

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

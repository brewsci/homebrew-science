class InterViews < Formula
  homepage "http://www.neuron.yale.edu/neuron/"

  stable do
    url "http://www.neuron.yale.edu/ftp/neuron/versions/v7.3/iv-18.tar.gz"
    sha256 "a875692a20211e0856e9e283ab9ef5da022b4d49853aa7f2f734104f399e7af1"
  end

  devel do
    url "http://www.neuron.yale.edu/ftp/neuron/versions/alpha/iv-19.tar.gz"
    sha256 "3cb76ad00ebf4282d4c586540f54624fef7ecf8cd3fa2e6b3075d8fdacdc42e0"
  end

  head "http://www.neuron.yale.edu/hg/neuron/iv", :using => :hg

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "4367f0c7ba84821a1bad6c8b6743972f3d10ad77ead55f02fcc10578b913f524" => :yosemite
    sha256 "f8ac5b2f5f664814b0088b236c84731ff09588d8462db4e8bba011b9591371ad" => :mavericks
    sha256 "667bc2bb4c4ab535733b7e89619a5945b46d0125a2eccfa44478c20e44448ca3" => :mountain_lion
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

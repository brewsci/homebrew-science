class K8 < Formula
  desc "Javascript shell based on Google's V8 Javascript engine"
  homepage "https://github.com/attractivechaos/k8"
  url "https://github.com/attractivechaos/k8/archive/v0.2.2.tar.gz"
  sha256 "b6bcb00329b5c2abbd3a1dce9566b80d97af67bf4fb0a08c698e324ac286642e"
  head "https://github.com/attractivechaos/k8.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9654eaff9d4b8b834e913e46b0a344166ef83f9f447b9003737157c1d4a07951" => :el_capitan
    sha256 "df19c8ef3a496fac0308865dd550d02f01696ff582a7a02890990aabf4c389a7" => :yosemite
    sha256 "5bb89b84c5f23d9311fef45cab5f222f7e454d1bc5c6d9c3d06db7f61728372a" => :mavericks
  end

  resource "v8" do
    url "https://github.com/v8/v8/archive/3.16.14.tar.gz"
    sha256 "8f74b34a499d61a15e4be73a694e6cc8e11f19ec17d1518f49892a84e218ae68"
  end

  def install
    resource("v8").stage buildpath/"v8"
    cd "v8" do
      system "make", "dependencies"
      system "make", "x64.release"
    end
    system *%W[#{ENV.cxx} #{ENV.cxxflags} -o k8 -Iv8/include k8.cc v8/out/x64.release/libv8_base.a v8/out/x64.release/libv8_snapshot.a -lpthread -lz]
    bin.install "k8"
    doc.install "README.md"
    prefix.install "k8.js"
  end

  test do
    system "#{bin}/k8", "--help"
  end
end

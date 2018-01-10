class Rainbow < Formula
  desc "Short reads clustering and local assembly"
  homepage "https://sourceforge.net/projects/bio-rainbow/"
  url "https://downloads.sourceforge.net/project/bio-rainbow/rainbow_2.0.4.tar.gz"
  sha256 "79281aae3bccd1ad467afef6fc7c8327aaa8d56f538821e2833d2b8f26b5bafc"

  bottle do
    cellar :any_skip_relocation
    sha256 "41925c1e06488b1f6128e71ee025a06cc459970edabc16f6d2534e5d532376cd" => :sierra
    sha256 "95f66f941f0f33811728ee0a4eb31e7b9d108fe1d6925cc10d12cb7c85dbc270" => :el_capitan
    sha256 "29a05932349dd5508d967e61f6524cc6a580b5a999935237587ec7563ef3272f" => :yosemite
    sha256 "153ce4090e380240431b515141c0c940213ffa091766d8dc716983fec890127c" => :x86_64_linux
  end

  def install
    system "make"
    bin.install %w[rainbow ezmsim rbasm]
  end

  test do
    system "#{bin}/rainbow 2>&1 |grep -q rainbow"
  end
end

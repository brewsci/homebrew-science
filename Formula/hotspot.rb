class Hotspot < Formula
  desc "Identify regions of local enrichment of short-read sequence tags"
  homepage "https://github.com/rthurman/hotspot"
  url "https://github.com/rthurman/hotspot/archive/v4.1.0.tar.gz"
  sha256 "9ecdbba612b80f137b78314c23ac94aa6840d217bf4256faf8adee88a73fdd0c"
  revision 2

  head "https://github.com/rthurman/hotspot.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-science"
    sha256 cellar: :any, sierra:       "e10854edf239f5e85f11b77ab48235aa9a68bfc2184e622a03e26d17be45f3df"
    sha256 cellar: :any, el_capitan:   "c32b4b12e774d784ce592bb565c1905eec6b007d0a587bb806b46c2d0a0be06f"
    sha256 cellar: :any, yosemite:     "35da611217337015692fadf3c41e7e0c24d59d419f20847ec3fd732bb6bf6637"
    sha256 cellar: :any, x86_64_linux: "cd399ba58e6fa37937630411aa6814349c049e2ec96d57615c26a07967f65492"
  end

  depends_on "gsl"

  def install
    ENV.deparallelize
    system "make", "-C", "hotspot-distr/hotspot-deploy"

    inreplace "hotspot-distr/pipeline-scripts/test/runall.tokens.txt",
              "/full/path/to/hotspot-distr", pkgshare
    pkgshare.install "hotspot-distr/pipeline-scripts", "hotspot-distr/data"

    bin.install Dir["hotspot-distr/hotspot-deploy/bin/*"]
    rm bin/"wavelets" unless OS.linux?
  end

  def caveats
    <<~EOS
      Run the test suite (~1 hr):
        #{opt_pkgshare}/pipeline-scripts/test/runhotspot
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/hotspot 2>&1", 1)
  end
end

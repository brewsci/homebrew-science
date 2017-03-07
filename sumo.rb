class Sumo < Formula
  desc "Simulation of Urban Mobility"
  homepage "https://sourceforge.net/projects/sumo/"
  url "https://downloads.sourceforge.net/project/sumo/sumo/version%200.29.0/sumo-all-0.29.0.tar.gz"
  sha256 "e6ba07ea9fdd93505e42e135a15ffc6727b877be02d649b7f31d102551155e65"

  bottle do
    cellar :any
    sha256 "6b4523651fe0495c0bea9a90fa2a700dbd7f0e0c2068f3b6cfdb16f21489086f" => :sierra
    sha256 "3ec6fbfe135f739b5aaceb5a58c22c5e366cba91d026557b8d98f0a388653b58" => :el_capitan
    sha256 "f8d68c4437fd3ee8977c8fb0eaa041f376ff8a1d5cae535cc91253317bb8968a" => :yosemite
  end

  option "with-test", "Enable additional build-time checking"

  deprecated_option "with-check" => "with-test"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :x11
  depends_on "xerces-c"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "proj"
  depends_on "gdal"
  depends_on "fox"
  depends_on :python

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.7.0.tar.gz"
    sha256 "f73a6546fdf9fce9ff93a5015e0333a8af3062a152a9ad6bcb772c96687016cc"
  end

  resource "TextTest" do
    url "https://pypi.python.org/packages/source/T/TextTest/TextTest-3.28.2.zip"
    sha256 "2343b59425da2f24e3f9bea896e212e4caa370786c0a71312a4d9bd90ce1033b"
  end

  def install
    resource("gtest").stage do
      system "autoreconf", "-fvi"
      system "./configure"
      system "make"
      buildpath.install "../googletest-release-1.7.0"
    end

    ENV["LDFLAGS"] = "-lpython" # My compilation fails without this flag, despite :python dependency.
    ENV.append_to_cflags "-I#{buildpath}/googletest-release-1.7.0/include"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python",
                          "--with-gtest-config=googletest-release-1.7.0/scripts/gtest-config"

    system "make", "install"

    # Copy tools/ and data/ to cellar. These contain some Python modules that have no setup.py.
    prefix.install "tools", "data"

    # Basic tests, they are fast, so execute them always.
    system "unittest/src/sumo-unittest"

    # Additional tests. These take more time, and some fail on my machine...
    if build.with? "test"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"
      resource("TextTest").stage { Language::Python.setup_install "python", buildpath/"vendor" }
      ENV.prepend_create_path "PATH", buildpath/"vendor/bin"
      system "tests/runTests.sh", "-l", "-zen", "-b", "homebrew-compilation-check"
    end

    rm bin/"sumo-unittest"
  end

  def caveats; <<-EOS.undent
    Some SUMO scripts require SUMO_HOME environmental variable:
      export SUMO_HOME=#{prefix}
    EOS
  end

  test do
    # A simple hand-made test to see if sumo compiled and linked well.

    (testpath/"hello.nod.xml").write <<-EOS.undent
      <nodes>
          <node id="1" x="-250.0" y="0.0" />
          <node id="2" x="+250.0" y="0.0" />
          <node id="3" x="+251.0" y="0.0" />
      </nodes>
    EOS

    (testpath/"hello.edg.xml").write <<-EOS.undent
      <edges>
          <edge from="1" id="1to2" to="2" />
          <edge from="2" id="out" to="3" />
      </edges>
    EOS

    system "#{bin}/netconvert", "--node-files=#{testpath}/hello.nod.xml", "--edge-files=#{testpath}/hello.edg.xml", "--output-file=#{testpath}/hello.net.xml"

    (testpath/"hello.rou.xml").write <<-EOS.undent
      <routes>
          <vType accel="1.0" decel="5.0" id="Car" length="2.0" maxSpeed="100.0" sigma="0.0" />
          <route id="route0" edges="1to2 out"/>
          <vehicle depart="1" id="veh0" route="route0" type="Car" />
      </routes>
    EOS

    (testpath/"hello.sumocfg").write <<-EOS.undent
      <configuration>
          <input>
              <net-file value="hello.net.xml"/>
              <route-files value="hello.rou.xml"/>
          </input>
          <time>
              <begin value="0"/>
              <end value="10000"/>
          </time>
      </configuration>
    EOS

    system "#{bin}/sumo", "-c", "hello.sumocfg"
  end
end

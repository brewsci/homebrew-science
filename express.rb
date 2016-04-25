class Express < Formula
  desc "Streaming quantification for sequencing"
  homepage "http://bio.math.berkeley.edu/eXpress/"
  url "http://bio.math.berkeley.edu/eXpress/downloads/express-1.5.1/express-1.5.1-src.tgz"
  sha256 "0c5840a42da830fd8701dda8eef13f4792248bab4e56d665a0e2ca075aff2c0f"
  revision 1
  head "https://github.com/adarob/eXpress.git"
  bottle do
    cellar :any
    sha256 "1df5c671148e3ed22449a072021d1b8712b659915f484d21c49ed9636130a356" => :el_capitan
    sha256 "f7b5b99f8574cbacf4a939d4fd97f1f4368d6fbef6202eec702aaa8351e729ac" => :yosemite
    sha256 "accc81bedabfad4cd4c770272d770908711fd8c7099c2fd005daeaafd224af9b" => :mavericks
  end

  # doi "10.1038/nmeth.2251"
  # tag "bioinformatics"

  depends_on "bamtools"
  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "protobuf" => :recommended
  depends_on "gperftools" => :optional

  def install
    inreplace "CMakeLists.txt", "set(Boost_USE_STATIC_LIBS ON)", ""
    mkdir "bamtools"
    ln_s Formula["bamtools"].include/"bamtools", "bamtools/include"
    ln_s Formula["bamtools"].lib, "bamtools/"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/express 2>&1", 1)
  end
end

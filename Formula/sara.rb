class Sara < Formula
  desc "Reachability analysis in petri nets"
  homepage "http://service-technology.org/sara"
  url "http://download.gna.org/service-tech/sara/sara-1.13.tar.gz"
  sha256 "2e1a616b6398bfc898b6a53aab16ef556ad59263b3ab71620592f83c43cd28ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "60b8a6294382332b395b48cf3bb59288994866615b230454d5b0bd7bb53f9d08" => :sierra
    sha256 "683d93ac898b70ceca17ca8444c871661b9b4960d7dcbed16318005747616a86" => :el_capitan
    sha256 "b45931a85e9884640c4f5995ed6c1b31bdb603857acec25d4c9e0164427cf917" => :yosemite
  end

  head do
    url "http://svn.gna.org/svn/service-tech/trunk/sara"
    depends_on "gengetopt" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "perform build-time checks"
  deprecated_option "without-check" => "without-test"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.deparallelize

    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--without-pnapi",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end

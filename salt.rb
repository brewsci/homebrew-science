class Salt < Formula
  homepage "http://supernovae.in2p3.fr/salt/doku.php?id=start"
  url "http://supernovae.in2p3.fr/salt/lib/exe/fetch.php?media=snfit-2.4.0.tar.gz"
  sha256 "c38bbf8765aadf321ee138457544264b9f3f5e33c0b178dd5f079d117a2befb8"
  version "2.4"
  revision 1

  bottle do
    cellar :any
    sha256 "23fbf4a3c5c15634f415157979aee92c9eaf20cf435c59266c8361f458361fa1" => :sierra
    sha256 "7b43e7bb615bfa9105a306c5410d0997036ada34259b9d465ff7a876225ba3ef" => :el_capitan
    sha256 "51e4079277a0068c0a14622297e59ee4db6b645b93068eeb2514ffeab03e0a47" => :yosemite
  end

  depends_on :fortran

  conflicts_with "fastbit", :because => "both install `include/filter.h`"

  resource "data" do
    url "http://supernovae.in2p3.fr/salt/lib/exe/fetch.php?media=salt2-4_data.tgz"
    sha256 "4942143a5c1b1e67eddebf6fdfea7862ebdad9ee9ed3db5704a9099dae820aa9"
  end

  resource "03d4ag" do
    url "http://supernovae.in2p3.fr/salt/lib/exe/fetch.php?media=jla-03d4ag.tar.gz"
    sha256 "b02ce0a2f9feb81e0a2423dd0a00b014403e5495c39f0b866a318ed894afa974"
  end

  def install
    ENV.deparallelize
    # the libgfortran.a path needs to be set explicitly
    libgfortran = `$FC --print-file-name libgfortran.a`.chomp
    ENV.append "LDFLAGS", "-L#{File.dirname(libgfortran)} -lgfortran"
    system "./configure", "--prefix=#{prefix}", "--disable-static"
    system "make", "install"
    # install all the model data
    (prefix/"data").install resource("data")
    # for testing
    (prefix/"03d4ag").install resource("03d4ag")
  end

  test do
    ENV["SALTPATH"] = "#{prefix}/data"
    cp_r Dir["#{prefix}/03d4ag/*"], "."
    system bin/"snfit", testpath/"lc-03D4ag.list"
    assert File.exist?("result_salt2.dat")
  end

  def caveats
    <<-EOS.undent
    You should add the following to your .bashrc or equivalent:
      export SALTPATH=#{prefix}/data
    EOS
  end
end

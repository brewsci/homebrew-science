class Galib < Formula
  homepage "http://lancet.mit.edu/ga/"
  url "http://lancet.mit.edu/ga/dist/galib247.tgz"
  sha256 "ea76b66ce4db4db2ed86e20d6d3ff144abaf73e33620104246639d9b2a465329"

  def install
    # https://github.com/B0RJA/GAlib-mpi/issues/1
    inreplace %W[ga/GA1DArrayGenome.C ga/GA2DArrayGenome.C ga/GA3DArrayGenome.C] do |s|
      s.gsub! "initializer(GA", "this->initializer(GA"
      s.gsub! "mutator(GA",     "this->mutator(GA"
      s.gsub! "comparator(GA",  "this->comparator(GA"
      s.gsub! "crossover(GA",   "this->crossover(GA"
    end

    # To avoid that 'libga.a' will be install as 'lib' and not *into* lib:
    lib.mkpath

    # Sometime builds fail. It's fast anyway, so lets deparallelize
    ENV.deparallelize
    system "make"
    system "make", "test"
    system "make", "DESTDIR=#{prefix}", "install"
  end
end

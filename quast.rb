class Quast < Formula
  desc "QUAST: Quality Assessment Tool for Genome Assemblies"
  homepage "http://cab.spbu.ru/software/quast/"
  # doi "10.1093/bioinformatics/btt086", "10.1093/bioinformatics/btv697", "10.1093/bioinformatics/btw379"
  # tag "bioinformatics"

  url "http://cab.spbu.ru/wp-content/uploads/2016/04/quast-4.4.1.tar.gz"
  sha256 "73ccf6bfc20503e6c72e0479a073aadd4319a36badba15b0810217b27e078ea3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f8e532693e2489a28a352b642b7e49142b1dd37592cf4d26050965d73f67fe6" => :el_capitan
    sha256 "64dd1f0cc101b783aa966dc95b043f58d63cbbc497e39b037660dd5f1742c6bf" => :yosemite
    sha256 "8dba14eebd1739ff6c5b1f71f05c25dc63d2239dcd73fdeba17385871662f1f4" => :mavericks
    sha256 "78bfe6cbc0a5fdbd7d8316a45a3dc5ad6d55141e3f8fa2cefb6f80d1fbb9f5ed" => :x86_64_linux
  end

  if OS.mac? && MacOS.version <= :mountain_lion
    depends_on "homebrew/python/matplotlib"
  else
    # Mavericks and newer include matplotlib
    depends_on "matplotlib" => :python
  end
  depends_on "e-mem"

  def install
    # removing precompiled E-MEM binary causing troubles with brew audit
    rm "quast_libs/E-MEM-osx/e-mem"
    prefix.install Dir["*"]
    bin.install_symlink "../quast.py", "../metaquast.py",
      "quast.py" => "quast", "metaquast.py" => "metaquast"
    # Compile MUMmer, so that `brew test quast` does not fail.
    system "#{bin}/quast", "--test"
  end

  test do
    system "#{bin}/quast", "--test"
  end
end

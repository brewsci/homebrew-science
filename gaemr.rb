class Gaemr < Formula
  homepage "http://www.broadinstitute.org/software/gaemr/"
  #tag "bioinformatics"

  url "http://www.broadinstitute.org/software/gaemr/wp-content/uploads/2012/12/GAEMR-1.0.1.tar.gz"
  sha1 "3747204b177eb32bfc2a0adc239d920320a2ff09"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "f00e97db2e69268acafc58e44b8840e011ef788b" => :yosemite
    sha1 "8a6d07f2d64bf496a851b03663f238d0ccdce379" => :mavericks
    sha1 "3212881a78c9a4ac17c7f5d462c5c44e60323f13" => :mountain_lion
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink "../libexec/bin/GAEMR.py"
  end

  def caveats; <<-EOS.undent
    After install GAEMR, you must do these 3 things:

    1. Amend your UNIX PATH environmental variable to point to your
       installation of the GAEMR/bin directory:
       export PATH=#{libexec}/bin:$PATH
    2. Amend your UNIX PYTHONPATH environmental variable to point to
       your installation of the GAEMR directory:
       export PYTHONPATH=#{libexec}:$PYTHONPATH
    3. Change the path variables in
       #{libexec}/gaemr/PlatformConstant.py
       to reflect your installation for the various bioinformatics tools.
    EOS
  end

  test do
    system "PYTHONPATH=#{libexec} #{bin}/GAEMR.py --help"
  end
end

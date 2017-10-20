class Gaemr < Formula
  homepage "https://www.broadinstitute.org/software/gaemr/"
  # tag "bioinformatics"

  url "https://www.broadinstitute.org/software/gaemr/wp-content/uploads/2012/12/GAEMR-1.0.1.tar.gz"
  sha256 "cab1818e33b8ce9db2b25268206d73b5883f6c40843c258a72daba79e841d70a"

  bottle do
    cellar :any
    sha256 "95b6230d77b727f963437e3066b2c024054fea6087f145c946c8bcb47316999b" => :yosemite
    sha256 "afb3ea09dea99f67b72f3395ad81dc3b369cb7c0b2ef29dafe9127b22585b36e" => :mavericks
    sha256 "15139afc47141dfd4df15b9ad8f75b6801624b26fadd63be6b5bbd61b7657fda" => :mountain_lion
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
    system "PYTHONPATH=#{libexec}", "#{bin}/GAEMR.py", "--help"
  end
end

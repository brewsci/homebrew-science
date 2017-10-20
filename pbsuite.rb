class Pbsuite < Formula
  desc "PBJelly and PBHoney: Software for PacBio sequencing data"
  homepage "https://sourceforge.net/projects/pb-jelly/"
  url "https://downloads.sourceforge.net/project/pb-jelly/PBSuite_14.7.14.tgz"
  sha256 "98dcda7598f0ecf1a4223ba249f699add4438c60f01ae67b07fdca01142cf145"
  # doi "10.1371/journal.pone.0047768", "10.1186/1471-2105-15-180"
  # tag "bioinformatics"

  bottle :unneeded

  depends_on "blasr" => :recommended
  depends_on "python"

  conflicts_with "bedtools", :because => "Both install bin/bamToFastq"

  def install
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    Set the PYTHONPATH environment variable:
      export PYTHONPATH=#{opt_prefix}:$PYTHONPATH
    EOS
  end

  test do
    system "sh -c 'PYTHONPATH=#{prefix} python #{bin}/Jelly.py' 2>&1 |grep Jelly"
  end
end

require "formula"

class Pbsuite < Formula
  homepage "http://sourceforge.net/projects/pb-jelly/"
  #doi "10.1371/journal.pone.0047768"
  url "https://downloads.sourceforge.net/project/pb-jelly/PBSuite_14.5.13.tgz"
  sha1 "c0fc0311b6b954e696666a5c88a99755d583b076"

  conflicts_with "bedtools", :because => "Both install bin/bamToFastq"

  def caveats; <<-EOS.undent
    Set the PYTHONPATH environment variable:
      export PYTHONPATH=#{opt_prefix}:$PYTHONPATH
    EOS
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    system "sh -c 'PYTHONPATH=#{prefix} python #{bin}/Jelly.py' 2>&1 |grep Jelly"
  end
end

class Maude < Formula
  desc "reflective language for equationals and logic specifications."
  homepage "http://maude.cs.illinois.edu"
  url "http://maude.cs.illinois.edu/w/images/8/81/Maude27-osx.zip"
  version "2.7"
  sha256 "7b97f675ede00edb8435cee08ea41e5226eb8daf7dea7c52c7c79d70dd5fc0ff"

  def install
    bin.install "maude.darwin64" => "maude"
    prefix.install Dir["*.maude"]
  end

  def caveats; <<-EOS.undent
    To use Maude and its recources,
    you need to add the following to your ~/.bashrc:

    export MAUDE_LIB="#{HOMEBREW_PREFIX}/Cellar/#{name}/#{version}"
    EOS
  end

  test do
    # this will reveal any errors or warnings using maude
    system "echo", "''", "|", "maude"
  end
end

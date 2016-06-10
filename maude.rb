class Maude < Formula
  desc "reflective language for equationals and logic specifications."
  homepage "http://maude.cs.illinois.edu"
  url "http://maude.cs.illinois.edu/w/images/8/81/Maude27-osx.zip"
  version "2.7"
  sha256 "7b97f675ede00edb8435cee08ea41e5226eb8daf7dea7c52c7c79d70dd5fc0ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbdd5374a68789987374995e612f268dcda8afd8f6e493744884943a0f1ac7cb" => :el_capitan
    sha256 "3280a654d8d4248d8aaace8667f51e645e812b5cc2a87d1f3e24572578de238f" => :yosemite
    sha256 "3826c4e7c7361a826d10db6aafc82f58681968b1427658338e717669dd714ee3" => :mavericks
  end

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

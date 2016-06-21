class Rate4site < Formula
  desc "Compute site-specific evolutionary rates for an amino-acid sequence"
  homepage "http://www.tau.ac.il/~itaymay/cp/rate4site.html"
  url "ftp://rostlab.org/rate4site/rate4site-3.0.0.tar.gz"
  sha256 "5f748131bc2d10383c35c3141a835efa4ec1e7088cd9d8970e8024021aa509ac"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"seq.aln").write <<-EOS.undent
CLUSTAL V


Horse            KVFSKCELAHKLKAQEMDGFGGYSLANWVCMAEYESNFNTRAFNGKNANGSSDYGLFQLN
Langur           KIFERCELARTLKKLGLDGYKGVSLANWVCLAKWESGYNTEATNYNPGDESTDYGIFQIN
Human            KVFERCELARTLKRLGMDGYRGISLANWMCLAKWESGYNTRATNYNAGDRSTDYGIFQIN
Rat              KTYERCEFARTLKRNGMSGYYGVSLADWVCLAQHESNYNTQARNYDPGDQSTDYGIFQIN
Cow              KVFERCELARTLKKLGLDGYKGVSLANWLCLTKWESSYNTKATNYNPSSESTDYGIFQIN
Baboon           KIFERCELARTLKRLGLDGYRGISLANWVCLAKWESDYNTQATNYNPGDQSTDYGIFQIN


Horse            NKWWCKDNKRSSSNACNIMCSKLLDENIDDDISCAKRVVRDKGMSAWKAWVKHCKDKDLS
Langur           SRYWCNNGKPGAVDACHISCSALLQNNIADAVACAKRVVSDQGIRAWVAWRNHCQNKDVS
Human            SRYWCNDGKPGAVNACHLSCSALLQDNIADAVACAKRVVRDQGIRAWVAWRNRCQNRDVR
Rat              SRYWCNDGKPRAKNACGIPCSALLQDDITQAIQCAKRVVRDQGIRAWVAWQRHCKNRDLS
Cow              SKWWCNDGKPNAVDGCHVSCSELMENDIAKAVACAKKIVSEQGITAWVAWKSHCRDHDVS
Baboon           SHYWCNDGKPGAVNACHISCNALLQDNITDAVACAKRVVSDQGIRAWVAWRNHCQNRDVS


Horse            EYLASCNL
Langur           QYVKGCGV
Human            QYVQGCGV
Rat              GYIRNCGV
Cow              SYVEGCTL
Baboon           QYVQGCGV
EOS
    system "#{bin}/rate4site", "-s", "seq.aln"
  end
end

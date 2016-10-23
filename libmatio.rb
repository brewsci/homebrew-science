class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "http://matio.sourceforge.net"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.9/matio-1.5.9.tar.gz"
  sha256 "beb7f965831ec5b4ef43f8830ee1ef1c121cd98e11b0f6e1d98713d9f860c05c"

  bottle do
    cellar :any
    sha256 "c063177a44ec8ee57ae6b8dc32aa7acb863b1587d5474899c4258980aba3c5e8" => :el_capitan
    sha256 "ffd0f3dc499b02b8970f87447621d0b1e68a8984116cb31069abbc70e697f4ce" => :yosemite
    sha256 "93d19eb63acb97f6ade5a01556e26032680a2931154b73512ef2b132b9cd49ec" => :mavericks
  end

  option :universal
  option "with-hdf5", "Enable support for newer MAT files that use the HDF5-format"

  depends_on "hdf5" => :optional

  # sample MATLAB file from http://web.uvic.ca/~monahana/eos225/matlab_tutorial/tutorial_5/working_with_data.html
  resource "test_mat_file" do
    url "http://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
    sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
  end

  def install
    ENV.universal_binary if build.universal?
    args = %W[
      --prefix=#{prefix}
      --with-zlib=/usr
      --enable-extended-sparse=yes
    ]

    if build.with? "hdf5"
      args << "--with-hdf5=#{HOMEBREW_PREFIX}" << "--enable-mat73=yes"
    else
      args << "--with-hdf5=no"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("test_mat_file")
    mv "poc_data.mat.sfx", "test.mat"
    (testpath/"not-a-mat-file.mat").write("Not a mat file\n")
    (testpath/"mat.c").write <<-'EOS'.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <matio.h>
      #include <errno.h>
      int main(int argc, char **argv)
      {
        mat_t *matfp;
        errno = 0;
        matfp = Mat_Open(argv[1], MAT_ACC_RDONLY);
        if (NULL == matfp) {
          printf("errno %d", errno);
          return EXIT_FAILURE;
        }
        printf("errno %d", errno);
        Mat_Close(matfp);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    assert_equal "errno 2", shell_output("./mat no-such-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat not-a-mat-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat test.mat")
  end
end

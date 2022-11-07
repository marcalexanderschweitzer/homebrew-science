# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
 class Slepc < Formula
  desc ""
  homepage ""
  # url "http://slepc.upv.es/download/distrib/slepc-3.10.2.tar.gz"
  # sha256 "0594972293f6586458a54b7c1e1121b311a9c9449060355d52bb3bf09ad6812b"
  # url "http://slepc.upv.es/download/distrib/slepc-3.11.1.tar.gz"
  # sha256 "4816070d4ecfeea6212c6944cee22dc7b4763df1eaf6ab7847cc5ac5132608fb"
  # url "http://slepc.upv.es/download/distrib/slepc-3.11.2.tar.gz"
  # sha256 "cd6a73ac0c9f689c12f2987000a7a28fa7df53fdc069fb59a2bb148699e741dd"
  # url "http://slepc.upv.es/download/distrib/slepc-3.12.1.tar.gz"
  # sha256 "a1cc2e93a81c9f6b86abd81022c9d64b0dc2161e77fb54b987f963bc292e286d"
  # url "http://slepc.upv.es/download/distrib/slepc-3.12.2.tar.gz"
  # sha256 "a586ce572a928ed87f04961850992a9b8e741677397cbaa3fb028323eddf4598"
  # url "https://slepc.upv.es/download/distrib/slepc-3.13.3.tar.gz"
  # sha256 "23d179c22b4b2f22d29fa0ac0a62f5355a964d3bc245a667e9332347c5aa8f81"
  # url "https://slepc.upv.es/download/distrib/slepc-3.13.4.tar.gz"
  # sha256 "ddc9d58e1a4413218f4e67ea3b255b330bd389d67f394403a27caedf45afa496"
  # url "https://slepc.upv.es/download/distrib/slepc-3.14.1.tar.gz"
  # sha256 "cc78a15e34d26b3e6dde003d4a30064e595225f6185c1975bbd460cb5edd99c7"
  # url "https://slepc.upv.es/download/distrib/slepc-3.15.0.tar.gz"
  # sha256 "e53783ae13acadce274ea65c67186b5ab12332cf17125a694e21d598aa6b5f00"
  # url "https://slepc.upv.es/download/distrib/slepc-3.16.0.tar.gz"
  # sha256 "be7292b85430e52210eb389c4f434b67164e96d19498585e82d117e850d477f4"
  # url "https://slepc.upv.es/download/distrib/slepc-3.16.1.tar.gz"
  # sha256 "b1a8ad8db1ad88c60616e661ab48fc235d5a8b6965023cb6d691b9a2cfa94efb"
  # url "https://slepc.upv.es/download/distrib/slepc-3.17.1.tar.gz"
  # sha256 "11386cd3f4c0f9727af3c1c59141cc4bf5f83bdf7c50251de0845e406816f575"
  # url "https://slepc.upv.es/download/distrib/slepc-3.17.2.tar.gz"
  # sha256 "f784cca83a14156631d6e0f5726ca0778e259e1fe40c927607d5fb12d958d705"
  url "https://slepc.upv.es/download/distrib/slepc-3.18.1.tar.gz"
  sha256 f6e6e16d8399c3f94d187da9d4bfdfca160de50ebda7d63f6fa8ef417597e9b4

  option "with-blopex", "Download blopex library"

  depends_on "marcalexanderschweitzer/science/petsc"
  depends_on "open-mpi"
  depends_on "gcc"
  depends_on "hdf5-mpi"
  depends_on "arpack" => ["with-mpi"]

    def install
    ENV["SLEPC_DIR"] = Dir.getwd

    arch_real = "real"
    # ENV["PETSC_ARCH"] = arch_real
    # ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{arch_real}"
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}"
    system "./configure", "--with-arpack=1 --with-arpack-dir=#{Formula["arpack"].opt_lib}", "--with-arpack-lib=-lparpack,-larpack",
                          "--prefix=#{prefix}",
                          "--with-clean=true"
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"

    # arch_complex = "complex"
    # # ENV["PETSC_ARCH"] = arch_complex
    # ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{arch_complex}"
    # system "./configure", "--with-arpack=1 --with-arpack-dir=#{Formula["arpack"].opt_lib}", "--with-arpack-lib=-lparpack,-larpack",
    #                       "--prefix=#{prefix}/#{arch_complex}",
    #                       "--with-clean=true"
    # system "make"
    # system "make", "test" if build.with? "test"
    # system "make", "install"

    # Link what we need.
    # petsc_arch = arch_real

    # include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"],
    #                         "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    # lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    # prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    # doc.install "docs/slepc.pdf", Dir["docs/*.htm"], "docs/manualpages" # They're not really man pages.
    # pkgshare.install "share/slepc/datafiles"

    # install some tutorials for use in test block
    # pkgshare.install "src/eps/examples/tutorials"
  end

  def caveats; <<~EOS
    Set your SLEPC_DIR to #{opt_prefix}/real or #{opt_prefix}/complex.
    Fortran modules are in #{opt_prefix}/real/include and #{opt_prefix}/complex/include.
    EOS
  end

  # test do
  #   cp_r prefix/"share/slepc/tutorials", testpath
  #   Dir.chdir("tutorials") do
  #     system "mpicc", "ex1.c", "-I#{opt_include}", "-I#{Formula["petsc"].opt_include}", "-L#{Formula["petsc"].opt_lib}", "-lpetsc", "-L#{opt_lib}", "-lslepc", "-o", "ex1"
  #     system "mpirun -np 3 ex1 2>&1 | tee ex1.out"
  #     `cat ex1.out | tail -3 | awk '{print $NF}'`.split.each do |val|
  #       assert val.to_f < 1.0e-8
  #     end
  #   end
  # end
end
 class Petsc < Formula
  desc ""
  homepage "https://www.mcs.anl.gov/petsc/"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.8.3.tar.gz"
  # sha256 "5509e35d55d5ce9e92dbe7a83f5e509865aea2a4cc2d9f16f72b7a5ceaafed96"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.1.tar.gz"
  # sha256 "8e3455d2ef0aed637d4d8033dab752551e049a088f893610b799aa3188a5c246"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.2.tar.gz"
  # sha256 "65100189796f05991bb2e746f56eec27f8425f6eb901f8f08459ffd2a5e6c69a"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.3.tar.gz"
  # sha256 "8828fe1221f038d78a8eee3325cdb22ad1055a2f0671871815ee9f47365f93bb"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.10.3.tar.gz"
  # sha256 "f03650ea5592313dd2b8be7ae9cc498369da660185b58f9e98689a9bc355e982"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.10.4.tar.gz"
  # sha256 "1921b2208801d6e03b44035d65d6c11901dbfa6c13a5a0f23864c04f4832613a"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.11.1.tar.gz"
  # sha256 "d14ffc082bfa83cd1fc5a0486d264ef19e2e43356ed768918eaa028ebb9be9d4"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.11.3.tar.gz"
  # sha256 "8bee4a5ad37af85938ae755be182dcea255888b4f8b3d976bedc57e959280622"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.12.1.tar.gz"
  # sha256 "28c25cde288f689605f2160613feef45863c9ef3ceb2d1a44c2226b779938781"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.12.4.tar.gz"
  # sha256 "800a965dd01adac099a186588cda68e4fcb224af326d8aaf55978361c019258f"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.13.3.tar.gz"
  # sha256 "dc744895ee6b9c4491ff817bef0d3abd680c5e3c25e601be44240ce65ab4f337"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.13.5.tar.gz"
  # sha256 "10fc542dab961c8b17db35ad3a208cb184c237fc84e183817e38e6c7ab4b8732"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.14.2.tar.gz"
  # sha256 "87a04fd05cac20a2ec47094b7d18b96e0651257d8c768ced2ef7db270ecfb9cb"
  # url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.15.0.tar.gz"
  # sha256 "ac46db6bfcaaec8cd28335231076815bd5438f401a4a05e33736b4f9ff12e59a"
  # url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.16.0.tar.gz"
  # sha256 "5aaad7deea127a4790c8aa95c42fd9451ab10b5d6c68b226b92d4853002f438d"
  # url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.16.3.tar.gz"
  # sha256 "eff44c7e7f12991dc7d2b627c477807a215ce16c2ce8a1c78aa8237ddacf6ca5"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.17.2.tar.gz"
  sha256 "2313dd1ca41bf0ace68671ea6f8d4abf90011ed899f5e1e08658d3f18478359d"

  depends_on "cmake"
  depends_on "hdf5-mpi"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "marcalexanderschweitzer/science/parmetis"
  # depends_on "netcdf"
  # depends_on "superlu"
  depends_on "suite-sparse"

  def install
    ENV["CC"] = "mpicc"
    ENV["CXX"] = "mpicxx"
    ENV["F77"] = "mpif77"
    ENV["FC"] = "mpif90"
    ENV["PETSC_DIR"] = Dir.getwd

    arch_real = "real"
    ENV["PETSC_ARCH"] = arch_real
    system "./configure", "CC=mpicc", "CXX=mpicxx", "FC=mpif90", "F77=mpif77",
                          "--with-shared-libraries=1",
                          "--with-pthread=0",
                          "--with-openmp=0",
                          "--with-cxx-dialect=C++11",
                          "--prefix=#{prefix}/#{arch_real}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
                          "--with-scalapack-dir=#{Formula["scalapack"].opt_prefix}",
                          # "--with-netcdf-dir=#{Formula["netcdf"].opt_prefix}",
                          "--with-hdf5-dir=#{Formula["hdf5-mpi"].opt_prefix}",
                          "--with-suitesparse-dir=#{Formula["suite-sparse"].opt_prefix}",
                          "--with-metis-dir=#{Formula["metis"].opt_prefix}",
                          "--with-parmetis-dir=#{Formula["parmetis"].opt_prefix}",
                          # "--with-superlu-dir=#{Formula["superlu"].opt_prefix}",
                          "--with-netcdf=0",
                          # "--with-suitesparse=0",
                          "--with-sundials2=0",
                          "--download-superlu_dist", 
                          # "--download-mumps",
                          "--with-mumps-dir=/Users/marcalexanderschweitzer/Tools/Build/mumps/build/_deps/mumps-src",
                          "--download-hypre", 
                          # "--download-ml", 
                          "--with-x=0"
    system "make", "all"
    system "make", "install"

    system "make", "distclean"

    arch_complex = "complex"
    ENV["PETSC_ARCH"] = arch_complex
    system "./configure", "CC=mpicc", "CXX=mpicxx", "FC=mpif90", "F77=mpif77",
                          "--with-shared-libraries=1",
                          "--with-pthread=0",
                          "--with-openmp=0",
                          "--with-cxx-dialect=C++11",
                          "--prefix=#{prefix}/#{arch_complex}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-scalapack-dir=#{Formula["scalapack"].opt_prefix}",
                          # "--with-netcdf-dir=#{Formula["netcdf"].opt_prefix}",
                          "--with-hdf5-dir=#{Formula["hdf5-mpi"].opt_prefix}",
                          "--with-suitesparse-dir=#{Formula["suite-sparse"].opt_prefix}",
                          "--with-metis-dir=#{Formula["metis"].opt_prefix}",
                          "--with-parmetis-dir=#{Formula["parmetis"].opt_prefix}",
                          # "--with-superlu-dir=#{Formula["superlu"].opt_prefix}",
                          "--with-netcdf=0",
                          # "--with-suitesparse=0",
                          "--with-sundials2=0",
                          "--download-superlu_dist", 
                          # "--download-mumps",
                          "--with-mumps-dir=/Users/marcalexanderschweitzer/Tools/Build/mumps/build/_deps/mumps-src",
                          # "--download-hypre", 
                          # "--download-ml", 
                          "--with-x=0"
    system "make", "all"
    system "make", "install"

    petsc_arch = arch_real
    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"],
                                "#{prefix}/#{petsc_arch}/include/finclude",
                                "#{prefix}/#{petsc_arch}/include/petsc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    pkgshare.install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
  end

  test do
    test_case = "#{pkgshare}/examples/src/ksp/ksp/examples/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match /^Norm of error .+, Iterations/, line, "Unexpected output format"
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
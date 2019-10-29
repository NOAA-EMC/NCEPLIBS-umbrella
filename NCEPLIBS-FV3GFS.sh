#!/bin/sh
set -eux

#source ./machine-setup.sh > /dev/null 2>&1
cwd=`pwd`

# --------------------------------------------------------------
#
# Clean lib directory (libraries, modulefiles and incmod)
#
# --------------------------------------------------------------

cd $cwd/lib
#rm -rf src/* lib/* include/* modulefiles/* ext_libs/*
cd $cwd
##
## read setlib.conf and then either execute the git script directly and install
## or confirm the installation
##

SET_FILE='setlib.conf'
#SET_ID='standard'


#new_compile=false
#in_metatask=false
INSTALL_NR=0
cat $SET_FILE | while read -r line; do

  line="${line#"${line%%[![:space:]]*}"}"
  [[ ${#line} == 0 ]] && continue
  [[ $line == \#* ]] && continue

  if [[ $line == INSTALL* ]] ; then

#      unset APP
      LIBNAME=$(echo $line | cut -d'|' -f2 | sed -e 's/^ *//' -e 's/ *$//')
      VER=$(echo $line | cut -d'|' -f3 | sed -e 's/^ *//' -e 's/ *$//')
      LIBG=$(echo $line | cut -d'|' -f4)
      DENP=$(echo $line | cut -d'|' -f5)
      CPLV=$(echo $line | cut -d'|' -f6 | sed -e 's/^ *//' -e 's/ *$//')

      export LIBNAME
      export VER

#      [[ $SET_ID != ' ' && $SET != *${SET_ID}* ]] && continue
#      [[ $MACHINES != ' ' && $MACHINES != "${MACHINE_ID}" ]] && continue

      INSTALL_NR_DEP=${INSTALL_NR}
      (( INSTALL_NR += 1 ))

      foo="_"
      libst=$LIBNAME$foo$VER
      mkdir -p $cwd/lib/src
      mkdir $cwd/lib/src/$libst
      cd $cwd/lib/src/$libst
      if [[ $LIBG == NCEPLIBS* ]] ; then
#      git clone https://vlab.ncep.noaa.gov/code-review/NCEPLIBS-$LIBNAME
       git clone --recursive gerrit:NCEPLIBS-$LIBNAME
       cd NCEPLIBS-$LIBNAME
       git checkout tags/$libst
       
       if [ $LIBNAME == "landsfcutil" ]||[ $LIBNAME == "ip" ] ; then
       cd ../
       cp -fr ./NCEPLIBS-$LIBNAME/* ./
       else
       if [ -d "src" ] ; then
       cd ../
       cp -fr ./NCEPLIBS-$LIBNAME/src/* ./
       else
       cd ../
       cp -fr ./NCEPLIBS-$LIBNAME/* ./
       fi
       fi
       cp -f $cwd/lib/script/build/$LIBNAME ./build.sh
       cp -f $cwd/lib/script/unixmodule/$libst ./modulefile.template 
       rm -fr NCEPLIBS-$LIBNAME
       ./build.sh
      else
#=======temporal solution=================================
       git clone --recursive gerrit:NCEPLIBS-miscutil
       cd NCEPLIBS-miscutil
       git checkout tags/$libst
#       if [ -d "src" ]; then
#       cd ../
#       cp -fr ./NCEPLIBS-miscutil/src/* ./
#       else
       cd ../
       cp -fr ./NCEPLIBS-miscutil/* ./
#       fi
       cp -f $cwd/lib/script/build/$LIBNAME ./build.sh
       cp -f $cwd/lib/script/unixmodule/$libst ./modulefile.template
       rm -fr NCEPLIBS-miscutil
#======standard method====================================
#       git clone --recursive gerrit:$LIBNAME
#       cd $LIBNAME
#       git checkout tags/$libst
#       cd ../
#       cp -fr ./$LIBNAME/src/* ./
#       cp -f $cwd/lib/script/build/$LIBNAME ./build.sh
#       rm -fr $LIBNAME
#==========================================================
       ./build.sh
      fi
      cd $cwd

#      if [[ $ROCOTO == true ]]; then
#        rocoto_create_compile_task
#      elif [[ $ECFLOW == true ]]; then
#        ecflow_create_compile_task
#      else
#        ./compile.sh $PATHTR/FV3 $MACHINE_ID "${NEMS_VER}" $INSTALL_NR > ${LOG_DIR}/compile_${INSTALL_NR}.log 2>&1
#        echo " bash Compilei is done"
#      fi

    continue
  else
    die "Unknown command $line"
  fi
done < $SET_FILE


# --------------------------------------------------------------
#
# First independent libraries:
#
# --------------------------------------------------------------

#for lib in \
#    bacio         \
#    bufr         \
#    bufr         \
#    crtm           \
#    g2tmpl        \
#    gfsio         \
#    ip            \
#    ip            \
#    landsfcutil   \
#    nemsio        \
#    sfcio         \
#    sigio         \
#    sp            \
#    w3nco
#do
# mkdir $cwd/lib/src/$lib
# cd $cwd/lib/src/$lib
# git clone https://vlab.ncep.noaa.gov/code-review/NCEPLIBS-$lib
# cd $cwd
#done


exit

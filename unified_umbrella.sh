#!/bin/bash

 Server=hera
 Prefix=/scratch1/NCEPDEV/nceplibs/Hang.Lei/github/AAA
#/scratch2/NCEPDEV/nceplibs/Dexin.Zhang/scrub

declare -a LIBS_NAMES=(\
#                       bacio_v2.0.3 \
#                       g2_v3.1.1 \
#                       g2c_v1.6.0 \
#                       g2tmpl_v1.5.2 \
#                       ip_v3.0.2 \
#                       landsfcutil_v2.1.1 \
#                       nemsio_v2.2.4 \
#                       nemsiogfs_v2.2.1 \
#                       sfcio_v1.1.1 \
#                       sigio_v2.1.1 \
#                       sp_v2.0.3 \
                       w3emc_v2.4.0 \
#                       w3nco_v2.0.7 \
#                       bufr_v11.3.0 \
#                       g2c_v1.5.0 \
#                       ip2_v1.0.0 \
                       )
#declare -a LIBS_NAMES=(nemsiogfs_v2.2.1 w3emc_v2.3.1)
# declare -a LIBS_NAMES=(bufr_v11.3.0 g2c_v1.5.0 ip2_v1.0.0)
module load netcdf
 nemsioInc=$Prefix/include/nemsio_v2.2.4
 nemsioVer=v${nemsioInc##*_v}
 sigioInc4=$Prefix/include/sigio_v2.1.1_4
 sigioVer=v${sigioInc##*_v}
# netcdfInc=$NETCDF/include
 netcdfInc=$CPATH
 for Libv in ${LIBS_NAMES[@]}; do

   name=${Libv%%_v*}       # get name
   version=v${Libv##*_v}   # get version; not used in this script

module purge
## compiler ver ???
module load intel/18.0.5.274     # hera
#module load netcdf
## intel and etc. mpi ver ???
   [[ $name == nemsio* || $name == w3emc ]] && module load impi/2018.0.4

   [[ $name == nemsiogfs || $name == w3emc ]] && {
     export NEMSIO_INC=$nemsioInc
     export NEMSIO_VER=$nemsioVer
   }
   [[ $name == w3emc ]] && {
     export SIGIO_INC4=$sigioInc4
     export SIGIO_VER=$sigioVer
     export NETCDF_INC=$netcdfInc
   }

   NCEPLIBS-${name}/build_${name}.sh $Server libver=$Libv prefix=$Prefix

   [[ $name == nemsiogfs || $name == w3emc ]] && {
     export -n NEMSIO_INC
     export -n NEMSIO_VER
   }
   [[ $name == w3emc ]] && {
     export -n SIGIO_INC4
     export -n SIGIO_VER
   }

 done


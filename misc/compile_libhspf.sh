# compile_libhspf.sh
#
# This is a shell script to compile an HSPF shared object library "libhspf.so" 
# for linux or Unix environments
#
# David J. Lampert, PhD, PE
# djlampert@gmail.com
#
# Instructions: Copy this file into the HSPF122/lib3.0/src folder, and copy
# the "djl" directory into the folder also (it contains a few essential 
# modifications to the source); the folder is compressed at "HSPF13.zip"
#
# The end result of the script is a library that can be linked to other 
# programs or environments; the routines are consistent with those used in
# the "core" modules of PyHSPF such as "hspf.hsppy" that takes the UCI file 
# and messagefile paths as inputs and will run the main HSPF program
# the routines needed for WDM file manipulation are also accessible

# files from lib3.0/src/util

UTILF="UTCHAR.FOR Utdate.FOR UTGNRL.FOR UTNUMB.FOR UTSORT.FOR UTCPGN.FOR CKFSDG.FOR USCNVT.FOR DATSYS77.FOR"
UTILC="DIRLIS_ GETDIR_ MALLO~BA FILEN~AI"

# files from lib3.0/src/adwdm

ADWDM="UTWDMD.FOR UTWDMF.FOR utwdt1.FOR WDMESS.FOR WDATM1.FOR MSIMPT.FOR MSEXPT.FOR MSOPEN.FOR PRTFIL.FOR ZTWDMF.FOR ADUTIL.FOR USYSUX.FOR WDOPUX.FOR"

# files from lib3.0/src/wdm

WDM="WDBTCH.FOR WDATRB.FOR WDATM2.FOR WDSPTM.FOR WDIMPT.FOR WDEXPT.FOR WDTMS2.FOR WDTMS1.FOR WDTBLE.FOR WDTBL2.FOR WDDLG.FOR WDATRU.FOR TSBUFR.FOR WDTMS3.FOR WDMID.FOR"

# files from lib3.0/src/HSPF122

HSPF="HOSUPER.FOR HDATUT.FOR HGENUT.FOR HIMP.FOR himpgas.FOR HIMPQUA.FOR HIMPSLD.FOR HIMPWAT.FOR Hioosup.FOR HIOOSV.FOR HIOTSIN.FOR HIOUCI.FOR HIOWRK.FOR HPER.FOR HPERAGUT.FOR HPERAIR.FOR HPERGAS.FOR HPERMST.FOR HPERPES.FOR HPERPHO.FOR HPERQUA.FOR HPERSED.FOR HPERTMP.FOR HPERTRA.FOR HPERWAT.FOR HPERNIT.FOR HPERSNO.FOR HPRBUT.FOR HRCH.FOR HRCHACI.FOR HRCHCON.FOR HRCHGQU.FOR HRCHHTR.FOR HRCHNUT.FOR HRCHOXR.FOR HRCHPHC.FOR HRCHPLK.FOR HRCHRQ.FOR HRCHUT.FOR HRCHHYD.FOR HRCHSED.FOR HRINGEN.FOR HRINGEUT.FOR HRINOPUT.FOR HRINSEQ.FOR HRINTS.FOR HRUNUT.FOR HRUNTSGP.FOR HRUNTSGQ.FOR HRUNTSGT.FOR HRUNTSGW.FOR HRUNTSUT.FOR HRINTSS.FOR HRINWDM.FOR HRUNTSPT.FOR HRUNTSPW.FOR HTSINSI.FOR HTSINSZ.FOR HTSSUT.FOR HUTOP.FOR HUTOPINP.FOR HWDMUT.FOR HUTDURA.FOR Specact.FOR HSPF.FOR HSPFEC.FOR HSPFITAB.FOR HRINOPN.FOR HEXTUTIL.FOR"

HSPF12="HBMPRAC.FOR HREPORT.FOR HIOSTA.FOR HIRRIG.FOR HRCHSHD.FOR HPESTUT.FOR"
# make a new directory to work in

# files from djl

DJL="djl.f HFILES.FOR"
DJLincs="PMESFL.INC VERSN.inc Fversn.inc"

mkdir hspf13

# copy the files

for a in $UTILC
do 
    cp UTIL/$a.C hspf13/$a.c
done

for a in $UTILF
do 
    cp UTIL/$a hspf13
done

cp UTIL/*.INC hspf13

for a in $ADWDM
do
    cp ADWDM/$a hspf13
done

cp ADWDM/*.inc hspf13
cp ADWDM/*.INC hspf13

for a in $WDM
do
    cp WDM/$a hspf13
done

cp WDM/*.inc hspf13
cp WDM/*.INC hspf13

for a in $HSPF $HSPF12
do
    cp hspf122/$a hspf13
done

cp hspf122/*.inc hspf13
cp hspf122/*.INC hspf13

for a in $DJL $DJLincs
do
    cp djl/$a hspf13
done

cp HSPNODSS/HDSSX.FOR hspf13

# move into the new directory

cd hspf13

# lower the case of the include files 
# (the changes from HSPF11 really make this a pain)

for a in *.INC *.inc
do
    mv $a "`echo $a | tr "[:upper:]" "[:lower:]"`"
done

# make the objects

gcc -ansi -fPIC -c -O3 *.c
gfortran -c -O3 -fno-automatic -fno-align-commons -fPIC $UTILF $ADWDM $WDM $HSPF $HSPF12 $DJL HDSSX.FOR

# make the shared library

gfortran -o libhspf.so -shared *.o

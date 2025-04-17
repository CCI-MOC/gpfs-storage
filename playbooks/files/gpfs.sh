if ! echo ${PATH} | grep -q /usr/lpp/mmfs/bin ; then
        PATH=${PATH}:/usr/lpp/mmfs/bin
fi
if ! echo ${LD_LIBRARY_PATH} | grep -q /usr/lpp/mmfs/lib ; then
        LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lpp/mmfs/lib
fi

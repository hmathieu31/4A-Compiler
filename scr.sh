#!bin/bash
for i in tests/* ; do
    cat $i | ./comp
    echo "$? -O"
done
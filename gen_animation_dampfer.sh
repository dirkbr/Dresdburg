#!/bin/bash

HEIGHT=20
WIDTH=30
LENGTH=100
DURATION=200

#1: Hin (Richtung S. Schweiz)
#2: Rück (Richtung Dresden)
DIRECTION=$1

if [ -z "$DIRECTION" ]; then
  DIRECTION=1 
fi

if [ $DIRECTION -eq 1 ]
then

echo "["

for row in $( seq 0 $(($HEIGHT-1)) ); do    #X
for col in $( seq 0 $(($WIDTH-1)) ); do

    ((TILE_ID=$row*$WIDTH + $col))
    ((TILE_ID_VORLAGE=$row*$LENGTH + $col))
    echo "{ \"animation\":["
    
    # first frame:
    echo -n "{ \"duration\": 1000, \"tileid\": $TILE_ID_VORLAGE},"
    
    # middle frames:
    for frame in $(seq 1 $(( $LENGTH-$WIDTH-1 )) ); do
        echo -n "{ \"duration\":${DURATION}, \"tileid\":$(($TILE_ID_VORLAGE + $frame)) },"
    done
    
    # last frame:
    echo "{ \"duration\": 10000, \"tileid\": $(($TILE_ID_VORLAGE + $LENGTH-$WIDTH )) }"
    
    # tile, that is animated
    echo -n "], \"id\": $TILE_ID_VORLAGE }"
    
    if [ $row -ne $(($HEIGHT-1)) ] || [ $col -ne $(($WIDTH-1)) ]; then
        echo ","
        else 
        echo "]"
    fi
    
done
done

else #direction

echo "["

for row in $( seq 0 $(($HEIGHT-1)) ); do    #X
for col in $( seq 0 $(($WIDTH-1)) ); do

    ((TILE_ID=$row*$WIDTH + $col))
    ((TILE_ID_VORLAGE=$row*$LENGTH + $col))
    echo "{ \"animation\":["
    
    # first frame:
    echo -n "{ \"duration\": 1000, \"tileid\": $(($TILE_ID_VORLAGE + $LENGTH-$WIDTH )) },"
    
    # middle frames:
    for frame in $(seq $(( $LENGTH-$WIDTH-1 )) -1 1 ); do
        echo -n "{ \"duration\":${DURATION}, \"tileid\":$(($TILE_ID_VORLAGE + $frame)) },"
    done
    
    # last frame:
    echo "{ \"duration\": 10000, \"tileid\": $TILE_ID_VORLAGE }"
    
    # tile, that is animated
    echo -n "], \"id\": $(($TILE_ID_VORLAGE + $LENGTH-$WIDTH )) }"
    
    if [ $row -ne $(($HEIGHT-1)) ] || [ $col -ne $(($WIDTH-1)) ]; then
        echo ","
        else 
        echo "]"
    fi
    
done
done

fi #direction

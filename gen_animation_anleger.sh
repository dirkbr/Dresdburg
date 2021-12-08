#!/bin/bash

HEIGHT=20
WIDTH=30
LENGTH=100
DURATION=200


echo "["

for tile_id in $(seq 0 149) ; do

    row=$(( tile_id/$WIDTH ))
    col=$(( tile_id%$WIDTH ))
    TIME=24800

    echo "{ \"animation\":["
    echo  "{ \"duration\": 1000, \"tileid\": $tile_id },"     #first frame
    TIME=$(( $TIME-1000 ))
    
    # Rest frames
    for frame in $(seq 1 $(( $LENGTH-$WIDTH-1 )) ); do
        if [ $col -gt $frame ] ; then #animation
#             echo "frame:  $frame col: $col"
            echo  "{ \"duration\": ${DURATION}, \"tileid\": $(($tile_id - $frame)) },"
            TIME=$(( $TIME - $DURATION ))
        else #transparent rest frames
            if [ $TIME -gt 10000 ] ; then #split rest time into max. 10s frames
                echo  "{ \"duration\": 10000, \"tileid\": 0 },"
                TIME=$(( $TIME-10000 ))
            else
                echo  "{ \"duration\": $TIME , \"tileid\": 0 }"
                break
            fi
        fi
    done
    
    # tile, that is animated
    echo  "], \"id\": $tile_id }"

    echo ","
done

for tile_id in $(seq 150 269) ; do

    row=$(( tile_id/$WIDTH ))
    col=$(( tile_id%$WIDTH ))
    TIME=24800
    
    # calc idle time
#     echo -n "Tile: $tile_id:"
    IDLE_TIME=$(( $WIDTH-$col ))
#     echo -n " $IDLE_TIME"
    IDLE_TIME=$(( $IDLE_TIME*200 ))
#     echo -n " $IDLE_TIME"
    IDLE_TIME=$(( $IDLE_TIME+10000-200 ))
#     echo -n " $IDLE_TIME"
    IDLE_TIME=$(( 24800 - $IDLE_TIME ))
#     echo ", Idle: $IDLE_TIME" 
    
    echo "{ \"animation\":["
    
    # spend Idle time in tile 0
    while [ $IDLE_TIME -gt 0 ] ; do
        if [ $IDLE_TIME -gt 10000 ] ; then #split idle time into max. 10s frames
            echo  "{ \"duration\": 10000, \"tileid\": 0 },"
            IDLE_TIME=$(( $IDLE_TIME - 10000 ))
        else
            echo  "{ \"duration\": $IDLE_TIME , \"tileid\": 0 },"
            break
        fi
    done
    
    # first real frames of animation
    for frame in $(seq $(( $WIDTH-$col-1 )) -1 1 ); do
        echo  "{ \"duration\": ${DURATION}, \"tileid\": $(($tile_id + $frame)) },"
    done
    echo  "{ \"duration\": 10000, \"tileid\": $tile_id }" # last frame
    
    # tile, that is animated
    echo  "], \"id\": $tile_id }"

    echo ","
done

echo "{}"
echo "]"

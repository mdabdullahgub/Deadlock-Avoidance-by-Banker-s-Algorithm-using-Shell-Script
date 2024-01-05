#!/bin/bash

# Banker's Algorithm for Deadlock Avoidance

declare -a available
declare -a max
declare -a allocation
declare -a need
declare -a sequence

# Function to check if the system is in a safe state
function isSafe {
  local work=("${available[@]}")
  local finish=()
  local count=0

  for ((i=1; i<=$n; i++))
  do
    finish[$i]=0
  done

  while [ $count -lt $n ]
  do
    local found=false
    for ((i=1; i<=$n; i++))
    do
      if [ "${finish[$i]}" -eq 0 ]
      then
        local j
        for ((j=1; j<=$m; j++))
        do
          if [ "${need[$i,$j]}" -gt "${work[$j]}" ]
          then
            break
          fi
        done

        if [ $j -eq $((m+1)) ]
        then
          for ((j=1; j<=$m; j++))
          do
            work[$j]=$((work[$j] + ${allocation[$i,$j]}))
          done
          sequence[$count]=$i
          finish[$i]=1
          count=$((count + 1))
          found=true
        fi
      fi
    done

    if [ "$found" = false ]
    then
      echo "System is not in a safe state!"
      return 1
    fi
  done

  echo "System is in a safe state."
  return 0
}

# Prompting user for input
echo -n "Enter the number of processes: "
read n

echo -n "Enter the number of resources: "
read m

echo "Enter the available resources:"
for ((i=1; i<=$m; i++ ))
do
  read a
  available[$i]=$a
done

echo "Enter the maximum need matrix:"
for ((i=1; i<=$n; i++ ))
do
  echo "Maximum need for process $i:"
  for ((j=1; j<=$m; j++ ))
  do
    read b
    max[$i,$j]=$b
  done
done

echo "Enter the allocation matrix:"
for ((i=1; i<=$n; i++ ))
do
  echo "Allocation for process $i:"
  for ((j=1; j<=$m; j++ ))
  do
    read c
    allocation[$i,$j]=$c
    need[$i,$j]=$((max[$i,$j] - allocation[$i,$j]))
  done
done

# Checking if the system is in a safe state
isSafe
if [ $? -eq 0 ]
then
  echo -n "Safe Sequence: "
  for ((i=0; i<$n; i++))
  do
    echo -n "P${sequence[$i]} "
  done
  echo ""
fi

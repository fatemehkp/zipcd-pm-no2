#!/bin/bash
#set a job name  
#SBATCH --job-name=msfno2rc4
#################  
#a file for job output, you can check job progress
#SBATCH --output=msfno2rc4.out
#################
# a file for errors from the job
#SBATCH --error=msfno2rc4.err
#################
#time you think you need; default is one day
#in minutes in this case, hh:mm:ss
#SBATCH --time=24:00:00
#################
#number of tasks you are requesting
#SBATCH -n 50
#SBATCH --exclusive
#SBATCH --mem=100G
################
#partition to use
#SBATCH --partition=short
#################
#number of nodes to distribute n tasks across
#SBATCH -N 1
#################

sas msfno2rc4 -work  /scratch/fatemehkp/projects/Zipcode\ PM\ NO2/code

cd $work


sas msfno2rc4



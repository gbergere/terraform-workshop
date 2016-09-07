# Terraform WorkShop 1 - Introduction to Terraform (v0.7)


/!\ During all that workshop DO NOT ever create anything outside of terraform !!!

## Requirements:

* terraform (v0.7.3)
* awscli (1.10.56)

## Exercise 1:
Deploy an ec2 instance and make sure this machine is reachable by ssh.

* ec2
* security group
* ssh keypair

## Exercise 2:
Create a terraform project to prepare all the network part required to build any stack (vpc, subnets, …) and move your machine on it (probably need to taint it).

* vpc
* igw
* subnets
* route tables

## Exercise 3:
Move from one reachable machine to an HA stack with and ELB in front of an auto-scaling group who run nginx in docker.

* elb
* auto scaling group
* launch configuration
* *lifecycle*

## Exercise 4 (bonus):

* Get rid of all your static values in your project to make it totally dynamic (no hard coded value).
* Split your project in two different parts to have the network part as a standalone project to be able to run several stack on it…

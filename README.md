spark-ec2-manager
=================

Bash program to help create and manage AWS ec2 clusters for apache spark


Get the code
==============

Copy the raw file into your own script or
```
  $ git clone https://github.com/alextbok/spark-ec2-manager.git
```

How to use
===============
Run the script from the ec2 folder in your spark directory
```
  $ cd /path/to/spark-version/ec2
  $ bash /path/to/spark-ec2-manager.sh
```
or
```
  $ cp /path/to/spark-ec2-manager.sh /path/to/spark-version/ec2
  $ cd /path/to/spark-version/ec2
  $ ./spark-ec2-manager.sh
```

Once the script is run, its interactive REPL will help you get an ec2 cluster up and running!


Notes
=======
You will need to edit lines 4 and 5 in the script. To do this, you will need to have an Amazon ec2 key pair.
Log into your AWS account and navigate to Key Pairs on the left sidebar of the ec2 dashboard.

And obviously, don't forget to make the file executable
```
  $ chmod +x spark-ec2-manager.sh
```

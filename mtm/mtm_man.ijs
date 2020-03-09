NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

echo 0 : 0
man pages:
   jd_mtm_overview_jman_
   jd_mtm_demo_jman_
)

jd_mtm_overview_jman_=:  0 : 0
Jd multi task manager

CJ  - task  for jobs (request/response zmq_raw)
CW  - task  for write ops
CRS - tasks for read ops


SCJ  - socket jobs (request/response)
SCW  - socket for CW task
SCRn - socket(s) for CRS tasks

CW init  - CRS tasks not started ; winit'' ; fails if refs or varbyte

CRS init - CW idle ; rinit''

CW run
 insert runs concurrently with CRS - info-summary is arg for CRS runs
 other ops - run only when CRS all idle and runs rinit in each CRS task
 
CRS run
 mtmfix info-summary
  remap files that have changed size
  tlen set in table locale and any mapped headers
 
todo:
varbyte not supported (server init fails) but it could work with more work
 dat is easy (just like normal cols) but val needs mtmfix support
 
refs not supported (server init fails)
 insert to left cols could be supported with some work
 insert to right col is more complicated and needs thought

)

jd_mtm_demo_jman_=: 0 : 0
1. create mtm demo DB - only run once to create a new mtm db
   start new j session
   load'jd'
   load'~addons/mtm/demo/createmtmdb.ijs'
   createmtmdb''
   
2. start mtm server
   start new jconsole session
   load'~addons/mtm/mtm.ijs'
   init '~temp/jd/mtm'

   
3. start mtm client (same machine as server for testing)
   start new jconsole session
   load'~addons/mtm/mtm_client.ijs'
   init 65220
   msr'info summary'
   
   
   load'~addons/mtm/demo/test.ijs'
   runclient''
)


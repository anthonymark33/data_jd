NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

0 : 0
some applications require a db to be always available for
quick updates and slow queries would interfere with this

a solution is to replicate the src db in a snk db for queries

src db appends change ops to a log
snk db applies these to be a copy of the src db

overhead to append an op the log file is small
and is very fast compared to insert complexity

log even faster for src and snk if on ssd on a different drive

src and snk dbs are normally in different Jd tasks
and this makes good use of multiple cores

there could be more than 1 snk replicated from a src

this tutorial works with src and snk in the same task
and requires extra steps to avoid conflicts with file handles
)

0 : 0
!!! csvrd, csvrestore, and table-table ops
!!! are NOT recorded in src db rlog folder
!!! and they will NOT be reflected in the snk db
)

RLOG=: '~temp/jd/rlog' NB. folder to hold replicate info

jdadmin 0 NB. clean state
jdadminnew'src'
jd'repsrc ',RLOG NB. connect rlog folder to record replicate info
jd'info replicate'
jd'createtable f'
jd'createcol f a int'
jd'insert f';'a';23
jd'reads from f'

jdadminnew'snk'
NB. next line gets error as RLOG files are in use by the src
'replicate'jdae'repsnk ',RLOG NB. connect rlog folder - expected error

jdadmin 0 NB. close src db so rlog file handles are closed
jdadminnew'snk'
jd'repsnk ',RLOG NB. connect rlog folder
jd'info replicate'
jd'repupdate'    NB. update db from rlog
NB. result is count of Jd ops - that is, createtable, createcol, insert
jd'reads from f'

jdadmin 0 NB. close snk db so rlog file handles are closed
jdadmin'src'
jd'insert f';'a';222 333
jd'reads from f'

jdadmin 0 NB. close src db so rlog file handles are closed

jdadmin'snk'
jd'reads from f' NB. does not have latest
jd'repupdate'
jd'reads from f'

13!:12'' [ jdadmin :: 0: 'src' NB. error as rlog is in use by snk db

jdadmin 0
jdadmin'src'
jd'createtable g'
jd'createcol g t int'
jd'insert g';'t';i.5
jd'delete f';'a=222'
jd'info summary'
jd'read from f'
jd'read from g'

jdadmin 0
jdadmin'snk'
jd'info summary'
jd'repupdate'
jd'info summary'
jd'read from f'
jd'read from g'

0 : 0
src db can exist before snk repsrc is run
repsrc copies src db files to the rlog folder
and they are used to init the snk db when it does repsnk
)

jdadmin 0
jdadminnew'src'
jd'createtable f'
jd'createcol f a int'
jd'insert f';'a';i.3
jd'createtable g'
jd'createcol g t int'
jd'insert g';'t';23
jd'repsrc ',RLOG    NB. current db is copied to rlog folder
jd'insert g';'t';777 NB. recorded as new op in rlog folder
jd'renamecol g t tt'
jd'renametable g h'
jd'createtable p'
jd'createcol p a int'
jd'createcol p b int'
jd'insert p';'a';23;'b';24
jd'dropcol p a'
jd'createtable k'
jd'createcol k a int'
jd'insert k';'a';123
jd'droptable k'
jd'createtable i'
jd'createcol i a int'
jd'insert i';'a';i.4
jd'intx i a int1'
a=. jd'info schema'
b=. jd'info summary'

jdadmin 0 
jdadminnew'snk'
jd'repsnk ',RLOG
jd'info summary'
jd'repupdate'
assert a-:jd'info schema'
assert b-:jd'info summary'

jd'repkill' NB. no more replication
'not'jdae'repupdate'

jdadmin'src'
jd'repkill' NB. no more replication

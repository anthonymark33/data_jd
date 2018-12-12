NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
jdrt_z_=:      jdrt_jd_

coclass 'jd'


NB. boolean mask - names starting with jd
bjdn=: 3 : 0
(<'jd')=2{.each y
)

ophtmls=: _4}.each(>:#jpath JDP,'doc')}.each 1 dir JDP,'doc/Ops_*'

jdrt=: 3 : 0
setscriptlists''
if. (-.IFJHS)*.80607<:0".(fread'~system/config/version.txt')-.CRLF,'.' do.
 require'labs/labs'
 runtut=: lab_z_
else.
 require'~addons/ide/jhs/sp.ijs'
 runtut=: spx_jsp_
end.
builddemos''
if. ''-:y do.
 c=. (tuts i.each'/'){.each tuts
 c=. ~.c
 ;LF,~each(<'   jdrt '''),each c,each''''
elseif. -.5=(;:'basic csv demo op xtra')i.<y do.
 a=. tuts#~(<y)=(#y){.each tuts
 a=. _8}.each a
 a=. (>:#y)}.each a
 ;LF,~each(<'   jdrt '''),each a,each''''
elseif. 1 do.
 f=. ;{.tuts#~;+/each(<y,'_tut.ijs')E.each tuts
 'invalid tutorial name'assert 0~:#f
 runtut JDP,'tutorial/',f
end.
)

builddemos=: 3 : 0
b=. jdfread each'~temp/jd/northwind/jdclass';'~temp/jd/sandp/jdclass';'~temp/jd/sed/jdclass'
if. *./b=<'database' do. return. end.
echo'building demos - takes time'
if. IFQT do. wd'msgs' end.
load__ JDP,'demo/common.ijs'
builddemo__'northwind'
builddemo__'sandp'
builddemo__'sed'
jdadmin 0
)

NB. widows bug?
NB.  fexist seems to 'sync' file ops and prevents ftypex from giving wrong answer 
ftypex=: 3 : 0
fexist y
ftype  y
)

reduce =: 1 : ('u/ y';':';'for_z. |.x do. y=.z u y end.')

dcreate=: (1!:5 :: 0:) @ (fboxname@:>)
derase=: (1!:55 :: 0:) @ (fboxname@:>)

pack=: [: (,. ".&.>) ;: ::]
pdef=: 3 : '0 0$({."1 y)=: {:"1 y'
termSEP=: , (0 < #) # '/' -. {:
tocolumn=: ,. @: > each
strsplit=: #@[ }.each [ (E. <;.1 ]) ,

throw=: 13!:8&101

rethrow=: throw @ (13!:12@(''"_) , ])
throwmsg=: }. @ ({.~i.&LF) @ (13!:12)

NB. =========================================================
MAX_INT =: 2^64x
to_unsigned =: MAX_INT | x:

NB. =========================================================
NB. cutcommas - cut string on commas.
cutcommas=: stripsp each @ (a: -.~ <;._1) @ (','&,)
NB. cutnames - cut string on blanks or commas.
cutnames=: (a: -.~ e.&', ' <;._1 ]) @ (' '&,)
stripsp=: #~ (+. +./\ *. +./\.)@(' '&~:)
wherequoted=: ~:/\@:(=&'"' *. 1,'\'~:}:)
NB. deb, but only where y is not quoted
debq=: #~ wherequoted +. (+. (1: |. (> </\)))@(' '&~:)

blankquoted_jd_=: 3 : 0
if. ''-:y do. y return. end. NB. avoid bug in wherequoted
' ' (I.wherequoted y)}y
)


NB. =========================================================
coinserttofront =: 3 : 0
p=. ; <@(, 18!:2)"0  ;: :: ] y
p=. ~. p, (18!:2 coname'')
(p /: p = <,'z') 18!:2 coname''
)

NB. =========================================================
NB. dirsubdirs
NB. return sub directories in top level directory
NB. ignore any hidden files
dirsubdirs=: 3 : 0
r=. 1!:0 (termSEP y),'*'
if. 0=#r do. '' return. end.
{."1 r #~ '-d' -:("1) 1 4{"1 > 4{"1 r
)

NB. convert varbyte boxes from internal format
vbfix=: 3 : 0
c=. ;#each y
(n=. (0,}:+/\c),.c);;y
)

NB. delete folder
NB. allowed if jddeleteok
NB.  not allowed if jddropstop
NB.   not allowed if too few /s (/abc/def ok and /abc bad)
NB.    allowed if empty or jdclass or in ~temp
jddeletefolder=: 3 : 0
y=. (-'/'={:y)}.y NB. drop trailing /
y=. jpath y
('folder (F) locked by Jd'rplc 'F';y) assert -.(<y)e.{:"1 jdadminlk_jd_''
t=. y,'/' NB. ensure trailing /
if. -.fexist t,'jddeleteok' do.
 EDROPSTOP assert (0=ftypex) t,'/jddropstop'
 e=. 'delete ',y,' not allowed'
 e assert 3<:+/t='/'
 p=. jpath'~temp/'
 e assert (0=#fdir t,'*')+.(fexist t,'jdclass')+.p-:(#p){.t 
end.
r=. rmsub y
if. 0~:;{.r do.
 echo 'Jd info: jddeletefolder failed: ',y
 echo IFWIN#' see doc technical|wss'
 echo ' trying again'
 for. i.20 do.
  6!:3[3
  r=. rmsub y
  if. 0=;{.r do.
   echo' succeeded'
   y return. end.
 end.
 echo' failed!'
 'jddeletefolder' logtxt y;r
 'jddeletefolder failed' assert 0
end.
y
)

jddeletefolderok=: 3 : 0
t=. jpath y
t=. t,(-.'/'={:t)#'/' NB. ensure trailing /
''fwrite t,'jddeleteok'
y
)

NB. write (x 1) or erase (x 0) all jddropstop files in path
NB. x 0 erase - x 1 write
NB. y is '' or 'table' or 'table col'
jddropstop=: 3 : 0
1 jddropstop y
:
p=. dirpath(jdpath''),(deb y)rplc' ';'/'
p=. p,each<'/jddropstop'
if. x=0 do.
 ferase each p
else.
 a: fwrite each p
end.
i.0 0
)

jdcloseflush=: 3 : 0
f=. 'jdcloseflush',~jdpath''
if. y=0 do.
 ferase f
else.
 ''fwrite f
end. 
i.0 0
)


NB. Windows Search Service (content indexing, ...) and and other windows background tasks
NB. (antivirus?) can cause rmdir to fail. This problem is mitigated by doing rmdir several
NB. times as required with a sleep.

NB. similar to rmdir_j_
NB. host facilities delete folder
rmsub=: 3 : 0
y=. jpath y
d=. 1!:0 y
if. 1~:#d do. 0;'' return. end. NB. folder already empty
if. 'd'~:4{4 pick{.d do. ('not a folder: ',y) assert 0 end.
t=. ,&'/'^:('/'~:{:) jpathsep y
if. (<filecase_j_ t) e. filecase_j_@:((#t)&{.)&.> 1{"1 }.showmap_jmf_ '' do. ('contains mapped files: ',t) assert 0 end.
if. IFWIN do.
  r=. shell_jtask_ 'rmdir /S /Q ','"','"',~hostpathsep y
else.
  r=. hostcmd_j_ 'rm -rf ','"','"',~y NB. --preserve-root
end.
if. #r do. 1;r return. end.
6!:3^:(*#1!:0 y) 0.1 NB. sometimes required in windows so next test works
if. 0=#1!:0 y do.
 0;''
else.
 1;'delete did not complete'
end.
)

jdcreatefolder=: 3 : 0
t=. jpath y
for_n. ('/'=t)#i.#t=. t,'/'  do.
  1!:5 :: [ <n{.t
end.
('jdcreatefolder failed: ',y) assert 2=ftypex y
y
)

NB. routines for partition tables

NB. return sorted ptable suffixes ; Tlens
getparts=: 3 : 0
a=. y,PTM
d=. getdb''
n=. NAMES__d
b=. (<a)=(#a){.each n
b=. b*.(#a)<;#each n NB. remove f~
n=. b#n
c=. b#CHILDREN__d
n=. (#a)}.each n
t=. ;(3 : 'Tlen__y')"0 c
s=. /:n
n=. s{n
t=. s{t
n;t
)

NB. return sorted ptable suffixes for setting setting tab~ pcol
getpartsx=: 3 : 0
n=. (>:#y)}.each 2 }.getparttables y
)

NB. sorted partition table names (f, f~, f~..., ...)
NB. returns single table name if not partition table
NB. returns single table name if y is already a partition name (has a ~)
getparttables=: 3 : 0
if. PTM e.y do. <y return. end.
d=. getdb''
ns=. NAMES__d
ns=. /:~ns#~(<,y)=(ns i.each PTM){.each ns
if. 1<#ns do.
 t=. jdgl ;{.ns
 'table (not a ptable) has partitions' assert S_ptable__t
end.
ns
)

NB. need general mechanism to log progress on long running operations
NB. this is a crude place holder for what is required
logprogress=: 3 : 0
try. y fwrite '~temp/jdprogress' catch. end.
)

NB. cd utilities
pointer_to =: 3 :'pointer_to_name ''y'''
pointer_to_name=: 1 { [: memr (0 4,JINT) ,~ symget@boxopen@,

gethad=: 1 { [: memr 0 4 4 ,~ [: symget <

NB. Date and time utils
toseconds =: (3 ((86400 * [: 3 :0 {."1) + (60 #. }."1)) (0,5#100)&#:) :. todatetime
y=.{."1 y [ m=.1{"1 y [ d=.{:"1 y
y=. 0 100 #: y - m <: 2
n=. +/"1 ]4 <.@%~ 146097 1461 *"1 y
n =. n + 10 <.@%~ 4 + (306 * 12 | m-3)  +  10 * d
n - 657378
)

todatetime =: (86400 ((1e6 * [: 3 :0 <.@%~) + 100 #. 0 60 60 #: |) ]) :. toseconds
a4=. 2629511 + 4*y
d4=. 4 (]-|) a4 - 146097 * c=. a4 <.@% 146097
d10=. 10 * 4 <.@%~ 7 + d4 - 1461 * y=. 1461 <.@%~ 3+d4
d=. 10 <.@%~ 4+d10-306* m=. 306 <.@%~ d10-6
(1e4*(c*100) + y + m>:10) + (100*1+12|m+2) + d
)

NB. format utils

NB. convert jd'...' table to HTML
tohtml=: 3 : 0
'</table>',~'<table>',;(<'<tr>'),.(tohtmlsub each y),.<'</tr>',LF
)

tohtmlsub=: 3 : 0
t=. y
if. 1=L.t do.
 t=. _1}.;t,each','
else.
 t=. ":t
 t=. }:,t,"1 LF
end.
t=. t rplc '&';'&amp;';'<';'&lt;';LF;'<br>'
t=. '<td>',t,'</td>'
)

totext=: 3 : ',LF,.~sptable y'

NB. convert jd'...' table to JSON
tojson =: verb define
if. 0=#y do. '' return. end.
'hdr dat'=. 2{.<"1 boxopen y
if. 0=#dat do. NB. no header was provided
 dat =. hdr
 hdr =. <@('column'&,)@":"0 i.#dat      NB. auto-generate column names
end.
NB.
 lbl      =. dquote each hdr
 colcount =. #dat
 rowcount =. #&>{.dat

 NB. format each column as JSON
 json =. (colcount) $ a:
 for_colndx. i. colcount do.
  col  =. (((>colndx{lbl),':'),])@dquote@escape_json_chars@dltb@":"1 each colndx{dat
  json =. col (colndx) } json
 end.
 NB. merge the individual JSON columns into a bi-dimensional char array
 json =. >((>@[) ,. ((rowcount,1)$',') ,. (>@])) / json
 NB. enclose each row between {} to represent JSON objects, add ',' and CRLF to the end of each row and raze the array
 json =. ;('{',])@(('},',CRLF),~])"1 json
 NB. amend in-place to discard the last ',' and CRLF
 json =. ' ' (-1 2 3) } json
 NB. enclose the resulting objects in [] to represent an array,
 json =. ('[',])@(']',~]) json
 NB. name the array
 json =. ('{"rows": ',])@('}',~]), json
)
escape_json_chars =: rplc&((_2[\CR;'\n';LF;'\r';TAB;'\t'), <;._2 @(,&' ');. _2 [0 : 0)
" \"
\ \\
/ \/
)

NB. Convert using escapes as in C printf (used in where clause parsing)
cescape =: ({. , ({.,$:@}.)@:cescape1@:}.)^:(<#)~ i.&'\'
NB. Argument starts with \
cescape1 =: 3 : 0 @: }. :: ('\'&,)
oct =. 8 {. hex =. 16 {. HEX =. '0123456789abcdefABCDEF'
char =. '"\abefnrtv'  [  res =. '"\',7 8 27 12 10 13 9 11{a.
select. {.y
  case. <"0 oct do. ((}. ,~ a.{~256|8#.oct i. {.)~ 3 <. i.&0@:e.&oct) y
  case. 'x' do.
    if. HEX -.@e.~ 1{y do. throw 'Missing hex digit for \x' end.
    ((}. ,~ a.{~16#.hex i. tolower@{.)~ 2 <. i.&0@:e.&HEX) }.y
  case. 'u';'U' do.
    if. HEX -.@e.~ 1{y do. throw 'Missing unicode digit for \',{.y end.
    l =. ((4 8{~'uU'i.{.) <. i.&0@:e.&HEX@:}.) y
    'c y' =. l (}. ;~ [:#:16#.hex i. tolower@{.) }.y
    n =. 5>.@%~<:@# c
    y ,~ a. {~ #. 1 (0,&.>i.n)} 1 0 ,"_ 1] _6 ]\ c {.~ _6*n
  case. <"0 char do. (}. ,~ res{~char i.{.) y
  case. do. '\',y
end.
)

NB. replace text in "s with blanks - phrase m59
blankq=: 3 : 0
' ' ((i.#y)#~(2:*./\0:,2:|+/\@(=&'"'))y)}y
)

TYPES=: <;._2 ]0 :0
boolean
int
float
byte
varbyte
date
datetime
edate
edatetime
edatetimem
edatetimen
int1
int2
int4
)

NB. 3!:0 TYPES values
TYPESj=: 1 4 8 2 4 4 4 4 4 4 4 4 4 1 1 1

jdfread=: 3 : 0
t=. fread y
if. (_1-:t)*.10=13!:11'' do.
 ('file read limit error (Technotes|file handles): ',;y)assert 0
end.
t
)
 
jdfwrite=: 4 : 0
t=. x fwrite y
if. (_1-:t)*.10=13!:11'' do.
 ('file write limit error (Technotes|file handles): ',;y)assert 0
end.
t
)

NB. jdsuffle 'table'
NB. (100<.#rows) random rows are deleted/inserted one row at a time
NB. (100<.#rows) random rows are deleted/insertt in bulk
NB. result is arg which allows: jdshuffle^:3 'foo'
jdshuffle=: 3 : 0
'tab'=. y
d=. /:~|:><"1 each ,.each {:jd'reads from ',tab

NB. shuffle random rows 1 at a time
v=. ((100<.>.0.25*#v){.?~#v){v=. ,>{:jd'reads jdindex from ',tab

for_i. v do.
 t=. jd'read from ',tab,' where jdindex=',":i
 jd ('delete ',tab);'jdindex=',":i
 jd ('insert ',tab);,t
end.

NB. shuffle random rows in bulk
v=. ((100<.>.0.25*#v){.?~#v){v=. ,>{:jd'reads jdindex from ',tab
test=. 'jdindex in (',(}.;',',each":each v),')'
t=. jd'read from ',tab,' where ',test
jd ('delete ',tab);test
jd ('insert ',tab);,t

z=. /:~|:><"1 each ,.each {:jd'reads from ',tab
'shuffle failed' assert d-:z
y
)

cnts=: ;:'writestate readstate map resize'

cntsclear=: 3 : 0
cntslast=: ;".each (<'cnts_'),each cnts,each <'_jd_'
".each (<'cnts_'),each cnts,each <'_jd_=:0'
cntslast
)

NB. http://code.jsoftware.com/wiki/Essays/Inverted_Table
ifa =: <@(>"1)@|:               NB. inverted from atoms
afi =: |:@:(<"_1@>)             NB. atoms from inverted

tassert=: 3 : 0
 assert. (1>:#$y) *. 32=3!:0 y  NB. boxed scalar or vector
 assert. 1=#~.#&>y              NB. same # items in each box (with at least one box)
 1
)

ttally    =: #@>@{.
tfrom     =: <@[ {&.> ]
tindexof  =: i.&>~@[ i.&|: i.&>
tmemberof =: i.&>~ e.&|: i.&>~@]
tless     =: <@:-.@tmemberof #&.> [
tnubsieve =: ~:@|:@:(i.&>)~
tnub      =: <@tnubsieve #&.> ]
tkey      =: 1 : '<@tindexof~@[ u/.&.> ]'
tgrade    =: > @ ((] /: {~)&.>/) @ (}: , /:&.>@{:)
tgradedown=: > @ ((] \: {~)&.>/) @ (}: , \:&.>@{:)
tsort     =: <@tgrade {&.> ]
tselfie   =: |:@:(i.~&>)

NB. alternatives
tmemberof1=: tindexof~ < ttally@]
tnubsieve1=: tindexof~ = i.@ttally
ranking   =: i.!.0~ { /:@/:
tgrade1   =: /: @ |: @: (ranking&>)

jdtypefromdata=: 3 : 0
typ=. ;(1 4 8 2 i. 3!:0 y){'boolean';'int';'float';'byte';'varbyte'
if. typ-:'varbyte' do.
 'varbyte bad shape'assert 1=$$y
 'varbyte bad shapes' assert 1>:;$@$each y
 'varbyte bad types' assert 2=;3!:0 each y
end.
typ
)

NB. get zip file from joftware jdcsv and unzip in CSVFOLDER
NB. used by bus_lic and qunadl_ibm tutorials
getcsv=: 3 : 0 NB. get csv file if it doesn't already exist
if. -.fexist CSVFOLDER__,y do.
 require'pacman' NB. httpget
 'rc fn'=. httpget_jpacman_'www.jsoftware.com/download/jdcsv/',(y{.~y i.'.'),'.zip'
 'httpget failed'assert 0=rc
 unzip=. ;(UNAME-:'Win'){'unzip';jpath'~tools/zip/unzip.exe'
 t=. '"',unzip,'" "',fn,'" -d "',(jpath CSVFOLDER__),'"'
 if. UNAME-:'Win' do. t=. '"',t,'"' end.
 r=. shell t
 ferase fn
 r,LF,'CSVFOLDER now contains the csv file'
else.
 'CSVFOLDER already contains the csv file'
end.
)

NB. jdzip file;folder
jdzip=: 3 : 0
'file folder'=: jpath each y
ferase file
zip=. ;(UNAME-:'Win'){'zip';jpath'~tools/zip/zip.exe'
t=. '"',zip,'" -r -j "',file,'" "',folder,'"'
if. UNAME-:'Win' do. t=. '"',t,'"' end.
echo t
r=. shell t
NB. ferase fn
NB. r,LF,'CSVFOLDER now contains the csv file'


)

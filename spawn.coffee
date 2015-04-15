ps = require 'child_process'
shm = require './build/Release/shm_addon'
data = null
workers = []

#Number of child processes
CHILDREN = 64
running = CHILDREN

#Prepare data
prepare = ->
 data = new Int32Array shm.createSHM()
 N = 1000
 i = 0
 n = 0
 while i < data.length
  n = 0 if n is N
  data[i] = n
  ++i
  ++n

#Start processes
start = ->
 console.log 'start'
 console.time 'count'
 for w in workers
  w.stdin.write 'start'

#Finished process
done = ->
 running--
 if running is 0
  console.timeEnd 'count'

#Spawn process
spawn = (n) ->
 w = ps.spawn 'coffee', ['child.coffee']

 w.stdout.on 'data', (msg) ->
  console.log "#{n}: #{msg}"
  done()

 w.stderr.on 'data', (msg) ->
  console.log "ERR: #{n}: #{msg}"

 w.on 'close', (status) ->
  #console.log "EXIT: #{n}: #{status}"

 workers.push w

#############

prepare()
for n in [0...CHILDREN]
 spawn n

#Wait for processes to initialize
setTimeout start, 2000

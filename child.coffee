shm = require './build/Release/shm_addon'

a = new Int32Array shm.createSHM()

start = ->
 c = 0
 k = 0
 while k < 1000
  t = 0
  i = 0
  while i < a.length
   if a[i] is k
    ++t
   ++i

  if t isnt 200
   throw new Error 'Counting error'
  c += t
  ++k

 console.log c
 process.exit()


process.stdin.on 'data', (msg) ->
 start()



#include <v8.h>
#include <node.h>
#include <iostream>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <string>

using namespace v8;
using namespace std;

char* data = NULL;
const int MEM = 800000; /* Two hundred thousand 32-bit integers */

void create() {
 int key = 6562;
 int shmid;

 if( (shmid = shmget( key, MEM, IPC_CREAT | 0666 )) < 0 )
  cout << "shmget failed" << endl;

 if( (data = (char *)shmat( shmid, NULL, 0 )) < 0 )
  cout << "shmat failed." << endl;
}

void CreateSHM(const FunctionCallbackInfo<Value>& args) {
 Isolate* isolate = Isolate::GetCurrent();
 HandleScope scope(isolate);

 /* If this is called by same node instance do not attach again */
 if(!data) {
  create();
 }

 /* Create a ArrayBuffer */
 Local<ArrayBuffer> buffer = ArrayBuffer::New(isolate, (void *)data, MEM);

 /* Return buffer */
 args.GetReturnValue().Set(buffer);
}

void init(Handle<Object> exports) {
  NODE_SET_METHOD(exports, "createSHM", CreateSHM);
}

NODE_MODULE(shm_addon, init)

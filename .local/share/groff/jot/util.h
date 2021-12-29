#define pdie(context) die(sys_errlist[errno], context);

void 
die(const char* reason, const char* context);

void* 
erealloc(void* vp, size_t size, const char* context);

void* 
emalloc(size_t size, const char* context);

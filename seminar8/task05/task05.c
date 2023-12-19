#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

typedef struct thread_args {
  pthread_mutex_t* m;
  char* word;
} thread_args;

void bad_print(char *s)
{
  for (; *s != '\0'; s++)
  {
    fprintf(stdout, "%c", *s);
    fflush(stdout);
    usleep(100);
  }
}

void* my_thread(void* arg)
{
  pthread_mutex_t* m = ((thread_args*) arg)->m;
  char* word = ((thread_args*) arg)->word;

  for(int i = 0; i < 10; i++ )
  {
    pthread_mutex_lock(m);
    bad_print(word);
    pthread_mutex_unlock(m);
    sleep(1);
  }
return NULL;
}

int main()
{
  pthread_t t1, t2;

  pthread_mutex_t m;
  pthread_mutex_init(&m, NULL);
  thread_args args1 = {.m = &m, .word = "Hello\n"};
  thread_args args2 = {.m = &m, .word = "World!\n"};

  pthread_create(&t1, NULL, my_thread, &args1);
  pthread_create(&t2, NULL, my_thread, &args2);
  pthread_join(t1, NULL);
  pthread_join(t2, NULL);

  pthread_mutex_destroy(&m);
  pthread_exit( NULL );
  return 0;
}

#include "SDL.h"
#include <GL/gl.h>

int
main (int c, char **a)
{
  int w = 400, h = 300;

  SDL_Event e;
        
  SDL_Init(32);
  SDL_SetVideoMode(w, h, 32, 2);

  while (!SDL_PollEvent (&e) || e.type!=2)
    {
      glClear (65<<8);

      glColor3d (1, 0.5, 0);
      glRectf (-1, -1, 1, 1); 

      SDL_GL_SwapBuffers ();
    }
}


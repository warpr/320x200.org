#include "SDL.h"

int
main (int c, char **a)
{
  int x, y, p, w = 400, h = 300, *v;

  SDL_Surface * b;
  SDL_Event e;

  SDL_Init(32);
  b = SDL_SetVideoMode(w, h, 32, 0);
  v = b->pixels;
  p = b->pitch/4;

  while (!SDL_PollEvent (&e) || e.type!=2)
    {
      SDL_LockSurface (b);

      for (y=0; y<h; y++)
        for (x=0; x<w; x++)
          v[y*p+x] = 0xFF8000;

      SDL_UnlockSurface (b);
      SDL_Flip (b);
    }
}


#include <stdlib.h>
#include <GL/glut.h>

void d ()
{
  glClear (65<<8);

  glColor3d (1, 0.5, 0);
  glRectf (-1, -1, 1, 1); 

  glutSwapBuffers ();
}

void k(unsigned char k, int x, int y) 
{
  exit (0);
}

int
main (int c, char **v)
{
  glutInit(&c, v);
  glutInitDisplayMode(18);
  glutCreateWindow(*v);
  glutDisplayFunc(d);
  glutKeyboardFunc(k);
  glutMainLoop();
}

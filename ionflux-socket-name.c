/* gcc -lX11 -lXext ionflux-socket-name.c -s -Os -o ionflux-socket-name */

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <stdio.h>

int main()
{
  Display *dpy = NULL;
  Atom atom, real_type;
  unsigned char *s;
  int status, format = 0;
  ulong n = -1, extra =  0;
  int more = True;
  ulong expected = 64L;
    
  dpy = XOpenDisplay(NULL);
    
  if (dpy == NULL) {
    printf("Unable to open display.\n");
    return 1;
  }
    
  atom = XInternAtom(dpy, "_ION_MOD_IONFLUX_SOCKET", True);
    
  if(atom == None) {
    printf("Missing atom. Ion not running?");
    return 1;
  }

  do {
    status = XGetWindowProperty(dpy, DefaultRootWindow(dpy), atom, 0L, expected,
                                False, XA_STRING, &real_type, &format, &n,
                                &extra, &s);

    if(status != Success || s == NULL)
      return 1;
    
    if(extra == 0 || !more)
      break;
        
    XFree((void*) s);
    expected += (extra + 4) / 4;
    more = False;
  } while(1);

  printf("%s", s);
  XCloseDisplay(dpy);

  return 0;
}

#define WIDTH  200
#define HEIGHT 200


int _width=0;
int _height=0;


//
// Lotsa copy pasta opengl code to be testing osmesa with
//

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

//Header file for AS3 interop APIs
//this is linked in by the compiler (when using flaccon)
#include "AS3.h"


void *buffer;


//#include "object.c"

#if 1

#include <GL/glu.h>
#include "GL/osmesa.h"

GLfloat light_diffuse[] = {1.0, 0.0, 0.0, 1.0};  /* Red diffuse light. */
GLfloat light_position[] = {1.0, 1.0, 1.0, 0.0};  /* Infinite light location. */
GLfloat n[6][3] = {  /* Normals for the 6 faces of a cube. */
  {-1.0, 0.0, 0.0}, {0.0, 1.0, 0.0}, {1.0, 0.0, 0.0},
  {0.0, -1.0, 0.0}, {0.0, 0.0, 1.0}, {0.0, 0.0, -1.0} };
GLint faces[6][4] = {  /* Vertex indices for the 6 faces of a cube. */
  {0, 1, 2, 3}, {3, 2, 6, 7}, {7, 6, 5, 4},
  {4, 5, 1, 0}, {5, 6, 2, 1}, {7, 4, 0, 3} };
GLfloat v[8][3];  /* Will be filled in with X,Y,Z vertexes. */

void
drawBox(void)
{
  int i;

  for (i = 0; i < 6; i++) {
    glBegin(GL_QUADS);
    glNormal3fv(&n[i][0]);
    glVertex3fv(&v[faces[i][0]][0]);
    glVertex3fv(&v[faces[i][1]][0]);
    glVertex3fv(&v[faces[i][2]][0]);
    glVertex3fv(&v[faces[i][3]][0]);
    glEnd();
  }
}


void
init(void)
{
  /* Setup cube vertex data. */
  v[0][0] = v[1][0] = v[2][0] = v[3][0] = -1;
  v[4][0] = v[5][0] = v[6][0] = v[7][0] = 1;
  v[0][1] = v[1][1] = v[4][1] = v[5][1] = -1;
  v[2][1] = v[3][1] = v[6][1] = v[7][1] = 1;
  v[0][2] = v[3][2] = v[4][2] = v[7][2] = 1;
  v[1][2] = v[2][2] = v[5][2] = v[6][2] = -1;

}

 

static void
write_targa(const char *filename, const GLubyte *buffer, int width, int height)
{
   FILE *f = fopen( filename, "w" );
   if (f) {
      int i, x, y;
      const GLubyte *ptr = buffer;
      printf ("osmesa test, writing tga file \n");
      fputc (0x00, f); /* ID Length, 0 => No ID */
      fputc (0x00, f); /* Color Map Type, 0 => No color map included */
      fputc (0x02, f); /* Image Type, 2 => Uncompressed, True-color Image */
      fputc (0x00, f); /* Next five bytes are about the color map entries */
      fputc (0x00, f); /* 2 bytes Index, 2 bytes length, 1 byte size */
      fputc (0x00, f);
      fputc (0x00, f);
      fputc (0x00, f);
      fputc (0x00, f); /* X-origin of Image */
      fputc (0x00, f);
      fputc (0x00, f); /* Y-origin of Image */
      fputc (0x00, f);
      fputc (WIDTH & 0xff, f);      /* Image Width */
      fputc ((WIDTH>>8) & 0xff, f);
      fputc (HEIGHT & 0xff, f);     /* Image Height */
      fputc ((HEIGHT>>8) & 0xff, f);
      fputc (0x18, f);  /* Pixel Depth, 0x18 => 24 Bits */
      fputc (0x20, f);  /* Image Descriptor */
      fclose(f);
      f = fopen( filename, "ab" );  /* reopen in binary append mode */
      for (y=height-1; y>=0; y--) {
         for (x=0; x<width; x++) {
            i = (y*width + x) * 4;
            fputc(ptr[i+2], f); /* write blue */
            fputc(ptr[i+1], f); /* write green */
            fputc(ptr[i], f);   /* write red */
         }
      }
      fclose(f);
   }

}

	

/*
int main(int argc, char **argv)
{

	
   OSMesaContext ctx;
 
   ctx = OSMesaCreateContextExt( OSMESA_RGBA, 16, 0, 0, NULL );

   if (!ctx) {
      printf("OSMesaCreateContext failed!\n");
      return 0;
   }
 
//   Allocate the image buffer 
   buffer = malloc( WIDTH * HEIGHT * 4 * sizeof(GLubyte) );
   if (!buffer) {
      printf("Alloc image buffer failed!\n");
      return 0;
   }
 
// Bind the buffer to the context and make it current
   if (!OSMesaMakeCurrent( ctx, buffer, GL_UNSIGNED_BYTE, WIDTH, HEIGHT )) {
      printf("OSMesaMakeCurrent failed!\n");
      return 0;
   }
 
   init();


    glShadeModel(GL_SMOOTH);
    glClearColor(0.0f, 0.0f, 0.0f, 0.5f);
    glClearDepth(1.0f);
 

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	drawBox();


	glFinish();

 
    write_targa("test.tga", buffer, WIDTH, HEIGHT);
 
   free( buffer );
   OSMesaDestroyContext( ctx );
   
  return 0;
}
*/

OSMesaContext ctx=0;
   
int setup_gl()
{
 
 
//   Allocate the image buffer 
//   buffer = malloc( WIDTH * HEIGHT * 4 * sizeof(GLubyte) );
   if (!buffer) {
      printf("Alloc image buffer failed!\n");
      return 0;
   }
   


	return 0;
}

int update_gl()
{
	
	return 0;
}

int clean_gl()
{
//    write_targa("test.tga", buffer, WIDTH, HEIGHT);
 
//   free( buffer );
	
   
	return 0;
}

#else

int setup_gl()
{
	
	return 0;
}

int tmp=0;
int update_gl()
{
int x,y;
unsigned int *cp;
	
	tmp=tmp+1;

	cp=(unsigned int *)buffer;
	for(y=0;y<_height;y++)
	{
		for(x=0;x<_width;x++)
		{
			*(cp++)=0xff112233+x+y+tmp;
		}
	}
	
	return 0;
}

int clean_gl()
{
//    write_targa("test.tga", buffer, WIDTH, HEIGHT);
 
//   free( buffer );
	return 0;
}


#endif




//Method exposed to ActionScript
static AS3_Val render(void *data, AS3_Val args)
//main()
{
int width=200;
int height=200;
int rotx=60;
int roty=0;
int rotz=-20;
//int i;

//int x,y;
//unsigned int *cp;

    init();
	
	AS3_ArrayValue(args, "IntType, IntType, IntType, IntType, IntType", &width, &height,&rotx,&roty,&rotz);
	
	if((_width!=width)||(_height!=height)) // new buffer request?
	{
		if(buffer)
		{
			free(buffer);
			buffer=0;
		}
		_width=width;
		_height=height;
	}
	
	if(!buffer) // allocate buffer
	{
	/* Allocate the image buffer */
	   buffer = malloc( width * height * 4 );
	   if (!buffer) {
		  return 0;
	   }
	   
	   setup_gl();
	}
	
   
//	for(i=0;i<10;i++)
//	{

   ctx = OSMesaCreateContextExt( OSMESA_RGBA, 16, 0, 0, NULL );

   if (!ctx) {
      printf("OSMesaCreateContext failed!\n");
//      return 0;
   }


  // Bind the buffer to the context and make it current
   if (!OSMesaMakeCurrent( ctx, buffer, GL_UNSIGNED_BYTE, _width, _height )) {
     printf("OSMesaMakeCurrent failed!\n");
//      return 0;
   }
   
	
    glShadeModel(GL_SMOOTH);
    glClearColor(0.0f, 0.0f, 0.0f, 0.5f);
    glClearDepth(1.0f);

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
  /* Enable a single OpenGL light. */
  glLightfv(GL_LIGHT0, GL_DIFFUSE, light_diffuse);
  glLightfv(GL_LIGHT0, GL_POSITION, light_position);
  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  /* Use depth buffering for hidden surface elimination. */
  glEnable(GL_DEPTH_TEST);

  /* Setup the view of the cube. */
  glMatrixMode(GL_PROJECTION);
  gluPerspective( /* field of view in degree */ 40.0,
    /* aspect ratio */ 1.0,
    /* Z near */ 1.0, /* Z far */ 10.0);
  glMatrixMode(GL_MODELVIEW);
   glPushMatrix ();
  gluLookAt(0.0, 0.0, 5.0,  /* eye is at (0,0,5) */
    0.0, 0.0, 0.0,      /* center is at (0,0,0) */
    0.0, 1.0, 0.);      /* up is in positive Y direction */

	
  /* Adjust cube position to be asthetic angle. */
  glTranslatef(0.0, 0.0, -1.0);
	
	glRotatef(rotx, 1.0, 0.0, 0.0);
	glRotatef(roty, 0.0, 1.0, 0.0);
	glRotatef(rotz, 0.0, 0.0, 1.0);

//
//chair05();
	drawBox();

   glPopMatrix ();
   
	glFinish();
	
   OSMesaDestroyContext( ctx );
   ctx=0;

//   }
//    write_targa("test.tga", buffer, _width, _height);
	
//	update_gl();
	
/*
	cp=(unsigned int *)buffer;
	for(y=0;y<height;y++)
	{
		for(x=0;x<width;x++)
		{
			*(cp++)=0xff112233+x;
		}
	}
*/
	
	
  return AS3_Ptr(buffer); // return start of buffer to as3

//	return 0;
}

//entry point for code
int main()
{

	//define the methods exposed to ActionScript
	//typed as an ActionScript Function instance
	AS3_Val renderV = AS3_Function( NULL, render );

	// construct an object that holds references to the functions
	AS3_Val result = AS3_Object( "render: AS3ValType", renderV );

	// Release
	AS3_Release( renderV );

	// notify that we initialized -- THIS DOES NOT RETURN!
	AS3_LibInit( result );

	// should never get here!
	return 0;
}







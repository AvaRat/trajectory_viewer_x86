/* example.c */
#include <stdio.h>
#include <inttypes.h>
#include <gtk/gtk.h>

/*     

  -m elf_i386 

-lgtk-x11-2.0 -lgdk-x11-2.0 \
-lpangocairo-1.0 -latk-1.0 -lcairo -lgdk_pixbuf-2.0 \
 -lgio-2.0 -lpangoft2-1.0 -lpango-1.0 -lgobject-2.0 \
 -lglib-2.0 -lfontconfig -lfreetype
 

int main(int argc, char *argv[]) 
{
	void extern sum(int64_t *a, int64_t b);
    int64_t b[10];
    b[0] = 78;
    b[1] = 2;
    b[2] = 3;
	sum(b, 9987);
    printf("wartosc przed powrotem: 78, 2, 3\n");
    printf("wartosc po powrocie: %ld, %ld, %ld\n", b[0], b[1], b[2]);
    return 0;
}
*/

int main(int argc, char **argv)
{
    GtkWidget *window;
    GtkWidget *main_box;
    GError *error = NULL;
    GtkWidget *image;
    GdkPixbuf *image_buff;

    window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
    g_signal_connect (window, "destroy",
                      G_CALLBACK (gtk_main_quit),
                      NULL);
    gtk_window_set_title (GTK_WINDOW (window), "displaying image");
    gtk_window_set_default_size(GTK_WINDOW(window), 640, 400);
    gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);

    main_box = gtk_hbox_new (FALSE, 0);
    gtk_container_add (GTK_CONTAINER (window), main_box);
    gtk_widget_show (main_box);



    image_buff = gdk_pixbuf_new_from_file("example_icon.png", &error);
    if(!image_buff)
    {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
        return -1;
    }



    image = gtk_image_new_from_pixbuf(image_buff);

    gtk_box_pack_start (GTK_BOX(main_box), image, TRUE, TRUE, 0);
    gtk_widget_show (image);

    gtk_widget_show (window);
    gtk_init (&argc, &argv);
    gtk_main ();
    return 0;
}
#include <gtk/gtk.h>


GdkPixbuf *create_pixbuf()
{
    GdkPixbuf *pixbuf;
    GError *error = NULL;
  //  pixbuf = gdk_pixbuf_new_from_file(filename, &error);
    pixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, FALSE, 8, 512, 256);
    if(!pixbuf)
    {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
    }

    return pixbuf;
}



int main(int argc, char *argv[]) {

    GtkWidget *window;
    GtkWidget *button;
    GtkWidget *main_box;
    GtkWidget *image;
    GtkWidget *scale;
    GtkWidget *spin_button;

    GError *error = NULL;

    GtkWidget *fixed_container;

    GdkPixbuf *icon;
    GdkPixbuf *image_buff;

    gtk_init(&argc, &argv);

    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "GUI practise");
    gtk_window_set_default_size(GTK_WINDOW(window), 1080, 720);
    gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
    gtk_container_set_border_width(GTK_CONTAINER(window), 10);

    button = gtk_button_new_with_label("button");
    gtk_widget_set_tooltip_text(button, "press button to do nothing ;)");

    main_box = gtk_fixed_new();
    gtk_container_add(GTK_CONTAINER(window), main_box);

 //   gtk_container_add(GTK_CONTAINER(halign), button);
 //   gtk_container_add(GTK_CONTAINER(window), halign);

    icon = gdk_pixbuf_new_from_file("trajectory_icon.png", &error);
    if(!icon)
    {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
        return -1;
    }
    gtk_window_set_icon(GTK_WINDOW(window), icon);

    
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);  

    image_buff = icon;
    image = gtk_image_new_from_pixbuf(image_buff);
    gtk_fixed_put (GTK_FIXED(main_box), image, 800, 100);
    

    scale = gtk_vscale_new_with_range(0, 100, 10);

    gtk_fixed_put (GTK_FIXED(main_box), scale, 100, 100);


    spin_button = gtk_spin_button_new_with_range(0, 20, 0.1);
    gtk_fixed_put (GTK_FIXED(main_box), spin_button, 400, 100);

    gtk_widget_show_all(window);
    gtk_main();

    return 0;
}

#include <gtk/gtk.h>

void extern draw(GdkPixbuf *buff, int width, int height);

static void
put_pixel (GdkPixbuf *pixbuf, int x, int y, guchar red, guchar green, guchar blue)
{
  int width, height, rowstride, n_channels;
  guchar *pixels, *p;

  n_channels = gdk_pixbuf_get_n_channels (pixbuf);

  g_assert (gdk_pixbuf_get_colorspace (pixbuf) == GDK_COLORSPACE_RGB);
  g_assert (gdk_pixbuf_get_bits_per_sample (pixbuf) == 8);
  g_assert (!gdk_pixbuf_get_has_alpha (pixbuf));
  g_assert (n_channels == 3);

  width = gdk_pixbuf_get_width (pixbuf);
  height = gdk_pixbuf_get_height (pixbuf);

  g_assert (x >= 0 && x < width);
  g_assert (y >= 0 && y < height);

  rowstride = gdk_pixbuf_get_rowstride (pixbuf);
  pixels = gdk_pixbuf_get_pixels (pixbuf);

  p = pixels + y * rowstride + x * n_channels;
  p[0] = red;
  p[1] = green;
  p[2] = blue;
}

static void scale_set_default_values( GtkScale *scale )
{
    gtk_range_set_update_policy (GTK_RANGE (scale),
                                 GTK_UPDATE_CONTINUOUS);
    gtk_scale_set_digits (scale, 1);
    gtk_scale_set_value_pos (scale, GTK_POS_TOP);
    gtk_scale_set_draw_value (scale, TRUE);
}

static void x_scale_moved(GtkRange *range, gpointer data)
{
    GError *error = NULL;
    GtkImage *image = data;
    GdkPixbuf *image_buff;
    image_buff = gdk_pixbuf_new_from_file("trajectory_icon.png", &error);
    if(!image_buff)
    {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
        return ;
    }
    gtk_image_set_from_pixbuf(image, image_buff);
}

static void y_scale_moved (GtkRange *range, gpointer  data)
{
    GError *error = NULL;
    GtkImage *image = data;
    GdkPixbuf *image_buff;
    int width = 256;
    int height = 256;

    image_buff = gdk_pixbuf_new(GDK_COLORSPACE_RGB, FALSE, 8, width, height);
    for(int y=0; y < height; ++y)
    {
        for(int x=0; x< width; ++x)
        {
            put_pixel(image_buff, x, y, 0, 0, 0);
        }
    }
    for(int x=0; x< height; ++x)
    {
        put_pixel(image_buff, x, x, 255, 255, 255);
    }
    if(!image_buff)
    {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
        return ;
    }
    gtk_image_set_from_pixbuf(image, image_buff);
 //   image = gtk_image_new_from_pixbuf(image_buff);
 //   gtk_widget_show (image);
}

static GtkWidget*
create_image (void)
{
  GtkWidget *image;
  GtkWidget *event_box;

  image = gtk_image_new_from_file ("myfile.png");

  event_box = gtk_event_box_new ();

  gtk_container_add (GTK_CONTAINER (event_box), image);
/*
  g_signal_connect (G_OBJECT (event_box),
                    "button_press_event",
                    G_CALLBACK (button_press_callback),
                    image);
*/
  return image;
}


int create_stuff()
{
    GtkWidget *window;
    GtkWidget *main_box;
    GtkWidget *box_image;
    GtkWidget *box1;
    GtkWidget *box2;
    GtkWidget *box3;
    GtkWidget *box4;
    GtkWidget *hscale1;
    GtkWidget *hscale2;
    GtkWidget *hscale3;
    GtkObject *adj1;
    GtkObject *adj2;
    GtkObject *adj3;

    GtkWidget *event_box;
    GdkPixbuf *icon;
    GtkWidget *image;
    GdkPixbuf *image_buff;
    GError *error = NULL;

    GtkWidget *sliders_box;

    GtkWidget *box_x;   // x box
    GtkWidget *box_y;   // y box
    GtkWidget *box_b;   //bounce box


    GtkWidget *x_label;
    GtkWidget *x_scale;
    GtkWidget *y_label;
    GtkWidget *y_scale;
    GtkWidget *b_label;
    GtkWidget *b_scale;

    adj1 = gtk_adjustment_new (0.0, 0.0, 10.0, 0.1, 1.0, 1.0);
    adj2 = gtk_adjustment_new (0.0, 0.0, 10.0, 0.1, 1.0, 1.0);
    adj3 = gtk_adjustment_new (0.0, 0.0, 100.0, 0.1, 1.0, 1.0);

    icon = gdk_pixbuf_new_from_file("trajectory_icon.png", &error);
    if(!icon)
    {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
        return -1;
    }

    window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
    g_signal_connect (window, "destroy",
                      G_CALLBACK (gtk_main_quit),
                      NULL);
    gtk_window_set_title (GTK_WINDOW (window), "displaying image");
    gtk_window_set_default_size(GTK_WINDOW(window), 640, 400);
    gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);

    gtk_window_set_icon(GTK_WINDOW(window), icon);

    // main window divider horizontally
    main_box = gtk_hbox_new (FALSE, 0);
    gtk_container_add (GTK_CONTAINER (window), main_box);
    gtk_widget_show (main_box);

    // sliders box
    sliders_box = gtk_vbox_new (TRUE, 10);
    gtk_container_set_border_width (GTK_CONTAINER (sliders_box), 10);
    gtk_box_pack_start (GTK_BOX (main_box), sliders_box, TRUE, TRUE, 0);
    gtk_widget_show (sliders_box);

    // image box
    image_buff = icon;
    image = gtk_image_new_from_pixbuf(image_buff);

    gtk_box_pack_start (GTK_BOX(main_box), image, TRUE, TRUE, 0);
    gtk_widget_show (image);


    // x_speed scale
    box_x = gtk_vbox_new (FALSE, 5);
    gtk_container_set_border_width (GTK_CONTAINER (box_x), 10);

    const gchar *x_label_text = "speed in x direction";
    x_label = gtk_label_new(x_label_text);

    x_scale = gtk_hscale_new (GTK_ADJUSTMENT (adj1));
    scale_set_default_values (GTK_SCALE (x_scale));

  //  gtk_misc_set_alignment (GTK_MISC(label_x), 0, 0);
    gtk_box_pack_start(GTK_BOX(box_x), x_label, TRUE, TRUE, 0);
    gtk_box_pack_start(GTK_BOX(box_x), x_scale, TRUE, TRUE, 0);
    gtk_box_pack_start (GTK_BOX(sliders_box), box_x, TRUE, TRUE, 0);

    gtk_widget_show(x_label);
    gtk_widget_show (x_scale);
    gtk_widget_show (box_x);

    
    // y_speed scale
    box_y = gtk_vbox_new (FALSE, 5);
    gtk_container_set_border_width (GTK_CONTAINER (box_y), 10);

    const gchar *y_label_text = "speed in y direction";
    y_label = gtk_label_new(y_label_text);

    y_scale = gtk_hscale_new (GTK_ADJUSTMENT (adj2));
    scale_set_default_values (GTK_SCALE (y_scale));

  //  gtk_misc_set_alignment (GTK_MISC(label_x), 0, 0);
    gtk_box_pack_start(GTK_BOX(box_y), y_label, TRUE, TRUE, 0);
    gtk_box_pack_start(GTK_BOX(box_y), y_scale, TRUE, TRUE, 0);
    gtk_box_pack_start (GTK_BOX(sliders_box), box_y, TRUE, TRUE, 0);

    gtk_widget_show(y_label);
    gtk_widget_show (y_scale);
    gtk_widget_show (box_y);



    // percentage of speed lost on bounce scale
    box_b = gtk_vbox_new (FALSE, 5);
    gtk_container_set_border_width (GTK_CONTAINER (box_b), 10);

    const gchar *b_label_text = "speed in y direction";
    b_label = gtk_label_new(b_label_text);

    b_scale = gtk_hscale_new (GTK_ADJUSTMENT (adj3));
    scale_set_default_values (GTK_SCALE (b_scale));

  //  gtk_misc_set_alignment (GTK_MISC(label_x), 0, 0);
    gtk_box_pack_start(GTK_BOX(box_b), b_label, TRUE, TRUE, 0);
    gtk_box_pack_start(GTK_BOX(box_b), b_scale, TRUE, TRUE, 0);
    gtk_box_pack_start (GTK_BOX(sliders_box), box_b, TRUE, TRUE, 0);

    gtk_widget_show(b_label);
    gtk_widget_show (b_scale);
    gtk_widget_show (box_b);

  
    gtk_range_set_update_policy (GTK_RANGE(x_scale), GTK_UPDATE_DISCONTINUOUS);
    gtk_range_set_update_policy (GTK_RANGE(y_scale), GTK_UPDATE_DISCONTINUOUS);
    gtk_range_set_update_policy (GTK_RANGE(b_scale), GTK_UPDATE_DISCONTINUOUS);
    int *a;
    int b = 99;
    a = &b;

    g_signal_connect (x_scale, "value-changed", G_CALLBACK(x_scale_moved), image);

    g_signal_connect (y_scale, "value-changed", G_CALLBACK(y_scale_moved), image);

    gtk_widget_show (window);
    return 0;
}


int main(int argc, char *argv[])
{
    gtk_init (&argc, &argv);

    if(create_stuff() != 0)
        return -1;
    else
        gtk_main ();
    return 0;
}
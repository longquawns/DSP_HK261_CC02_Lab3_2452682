// DSP LAB 3 - EXERCISE 6: LINEAR CONVOLUTION
// y(n) = x(n) * h(n)

clear;
clc;
funcprot(0);

function [yn, yorigin] = convolution(xn, xorigin, hn, horigin)
    xn = matrix(xn, 1, length(xn));
    hn = matrix(hn, 1, length(hn));

    if (length(xn) == 0) | (length(hn) == 0) then
        error("Both input vectors must be non-empty.");
    end
    if (xorigin < 1) | (xorigin > length(xn)) | ..
       (xorigin <> floor(xorigin)) then
        error("xorigin must be an integer from 1 to length(xn).");
    end
    if (horigin < 1) | (horigin > length(hn)) | ..
       (horigin <> floor(horigin)) then
        error("horigin must be an integer from 1 to length(hn).");
    end

    yn = convol(xn, hn);

    // The first output index is the sum of the first input indices.
    nx_start = 1 - xorigin;
    nh_start = 1 - horigin;
    ny_start = nx_start + nh_start;
    yorigin = 1 - ny_start;
endfunction

function draw_signal_ex6(n, samples, plot_title, ..
                         color_style, marker_spec)
    plot2d3(n, samples, color_style);
    stem_entity = gce();
    stem_entity.children.thickness = 3;

    plot(n, samples, marker_spec);
    marker_entity = gce();
    marker_entity.children.thickness = 2;
    marker_entity.children.mark_size = 6;

    axes_handle = gca();
    axes_handle.x_location = "origin";
    axes_handle.y_location = "left";
    axes_handle.grid = [1 1];
    axes_handle.box = "on";

    ymin = min([samples 0]);
    ymax = max([samples 0]);
    ypad = max([0.75, 0.20 * (ymax-ymin+1)]);
    axes_handle.data_bounds = ..
        [min(n)-1, ymin-ypad; max(n)+1, ymax+ypad];
    xtitle(plot_title, "Sample index n", "Amplitude");
endfunction

// Numerical example.
xn = [2, 1, 3, -1];
xorigin = 2;
hn = [1, 2, 1];
horigin = 1;

[yn, yorigin] = convolution(xn, xorigin, hn, horigin);

nx = (1:length(xn)) - xorigin;
nh = (1:length(hn)) - horigin;
ny = (1:length(yn)) - yorigin;

mprintf("\nEXERCISE 6 - CONVOLUTION y(n) = x(n) * h(n)\n");
mprintf("Output origin yorigin = %d\n", yorigin);
mprintf("Output time indices:\n");
disp(ny);
mprintf("Output samples yn:\n");
disp(yn);

scf(6);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Exercise 6 - Convolution";

subplot(3, 1, 1);
draw_signal_ex6(nx, xn, "Input signal x(n)", 2, "bo");

subplot(3, 1, 2);
draw_signal_ex6(nh, hn, "Impulse response h(n)", 3, "go");

subplot(3, 1, 3);
draw_signal_ex6(ny, yn, ..
                "Convolution y(n) = x(n) * h(n)", 5, "ro");

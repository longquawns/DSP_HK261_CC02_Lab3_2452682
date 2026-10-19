// DSP LAB 3 - EXERCISE 2: ADVANCE OPERATION
// y(n) = x(n+k), k > 0

clear;
clc;
funcprot(0);

function [yn, yorigin] = advance(xn, xorigin, k)
    xn = matrix(xn, 1, length(xn));

    if length(xn) == 0 then
        error("xn must be a non-empty vector.");
    end
    if (xorigin < 1) | (xorigin > length(xn)) | ..
       (xorigin <> floor(xorigin)) then
        error("xorigin must be an integer from 1 to length(xn).");
    end
    if (k <= 0) | (k <> floor(k)) then
        error("k must be a positive integer.");
    end

    // An advance changes the time labels but preserves all amplitudes.
    yn = xn;
    yorigin = xorigin + k;
endfunction

function draw_signal_ex2(n, samples, plot_title, ..
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
xn = [1, 2, 3, 4, 5];
xorigin = 3;
k = 2;

[yn, yorigin] = advance(xn, xorigin, k);

nx = (1:length(xn)) - xorigin;
ny = (1:length(yn)) - yorigin;

mprintf("\nEXERCISE 2 - ADVANCE y(n) = x(n+%d)\n", k);
mprintf("xorigin = %d, yorigin = %d\n", xorigin, yorigin);
mprintf("Time indices of x(n):\n");
disp(nx);
mprintf("Samples xn:\n");
disp(xn);
mprintf("Time indices of y(n):\n");
disp(ny);
mprintf("Samples yn:\n");
disp(yn);

scf(2);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Exercise 2 - Advance";

subplot(2, 1, 1);
draw_signal_ex2(nx, xn, "Original signal x(n)", 2, "bo");

subplot(2, 1, 2);
draw_signal_ex2(ny, yn, ..
                "Advanced signal y(n) = x(n+2)", 5, "ro");

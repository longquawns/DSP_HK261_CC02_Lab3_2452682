// ============================================================================
// DSP LAB 3 - EXERCISE 1: DELAY OF A DISCRETE-TIME SIGNAL
// Function: [yn, yorigin] = delay(xn, xorigin, k)
// Operation: y(n) = x(n-k), k > 0
//
// Convention: xorigin is the 1-based vector position corresponding to n = 0.
// No numerical rounding is performed.
// ============================================================================

clear;
clc;
funcprot(0);

// Compute the delayed sequence and its new origin position.
function [yn, yorigin] = delay(xn, xorigin, k)
    xn = matrix(xn, 1, length(xn));

    if length(xn) == 0 then
        error("xn must be a non-empty vector.");
    end
    if (xorigin < 1) | (xorigin > length(xn)) | (xorigin <> floor(xorigin)) then
        error("xorigin must be an integer from 1 to length(xn).");
    end
    if (k <= 0) | (k <> floor(k)) then
        error("k must be a positive integer.");
    end

    // A time shift does not change the sample amplitudes.
    yn = xn;

    // Since y(n)=x(n-k), all time indices move right by k.
    // Therefore, the vector position representing n=0 moves left by k.
    yorigin = xorigin - k;
endfunction

// Draw one finite-length discrete-time signal.
// marker_spec uses Scilab line specifications such as "bo" or "ro".
function draw_signal_ex1(n, samples, plot_title, color_style, marker_spec)
    // Draw the vertical stems.
    plot2d3(n, samples, color_style);
    stem_entity = gce();
    stem_entity.children.thickness = 3;

    // Overlay an unfilled circular marker at the tip of every stem.
    // Successive 2-D plots are superposed in Scilab, so this does not erase
    // the vertical bars drawn above.
    plot(n, samples, marker_spec);
    marker_entity = gce();
    marker_entity.children.thickness = 2;
    marker_entity.children.mark_size = 6;

    axes_handle = gca();
    axes_handle.x_location = "origin";
    // Keep the y-axis and the "Amplitude" label at the left border so they
    // never cover stems located near n=0.
    axes_handle.y_location = "left";
    axes_handle.grid = [1 1];
    axes_handle.box = "on";

    ymin = min([samples 0]);
    ymax = max([samples 0]);
    ypad = max([0.75, 0.20 * (ymax - ymin + 1)]);
    axes_handle.data_bounds = [min(n)-1, ymin-ypad; max(n)+1, ymax+ypad];
    xtitle(plot_title, "Sample index n", "Amplitude");
endfunction

// ------------------------------ Demonstration ------------------------------
// x(n) = {1, -2, 3, 6}, where the third element is x(0).
xn = [1, -2, 3, 6];
xorigin = 3;
k = 1;

[yn, yorigin] = delay(xn, xorigin, k);

nx = (1:length(xn)) - xorigin;
ny = (1:length(yn)) - yorigin;

mprintf("\nEXERCISE 1 - DELAY y(n) = x(n-%d)\n", k);
mprintf("xorigin = %d, yorigin = %d\n", xorigin, yorigin);
mprintf("Time indices of x(n):\n");
disp(nx);
mprintf("Samples xn:\n");
disp(xn);
mprintf("Time indices of y(n):\n");
disp(ny);
mprintf("Samples yn:\n");
disp(yn);

scf(1);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Exercise 1 - Delay";

subplot(2, 1, 1);
draw_signal_ex1(nx, xn, "Original signal x(n)", 2, "bo");

subplot(2, 1, 2);
draw_signal_ex1(ny, yn, "Delayed signal y(n) = x(n-1)", 5, "ro");


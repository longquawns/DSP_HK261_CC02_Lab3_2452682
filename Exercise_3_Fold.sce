// ============================================================================
// DSP LAB 3 - EXERCISE 3: FOLDING (TIME REVERSAL)
// Function: [yn, yorigin] = fold(xn, xorigin)
// Operation: y(n) = x(-n)
//
// Convention: xorigin is the 1-based vector position corresponding to n = 0.
// No numerical rounding is performed.
// ============================================================================

clear;
clc;
funcprot(0);

// Fold a finite-length sequence about n = 0.
function [yn, yorigin] = fold(xn, xorigin)
    xn = matrix(xn, 1, length(xn));

    if length(xn) == 0 then
        error("xn must be a non-empty vector.");
    end
    if (xorigin < 1) | (xorigin > length(xn)) | (xorigin <> floor(xorigin)) then
        error("xorigin must be an integer from 1 to length(xn).");
    end

    // Reverse the sample order.
    yn = xn($:-1:1);

    // Reflect the origin position inside the reversed vector.
    yorigin = length(xn) - xorigin + 1;
endfunction

function draw_signal_ex3(n, samples, plot_title, color_style, marker_spec)
    plot2d3(n, samples, color_style);
    stem_entity = gce();
    stem_entity.children.thickness = 3;

    // Add an unfilled circle at each sample value.
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
    ypad = max([0.75, 0.20 * (ymax - ymin + 1)]);
    axes_handle.data_bounds = [min(n)-1, ymin-ypad; max(n)+1, ymax+ypad];
    xtitle(plot_title, "Sample index n", "Amplitude");
endfunction

// ------------------------------ Demonstration ------------------------------
xn = [1, -2, 3, 6];
xorigin = 3;

[yn, yorigin] = fold(xn, xorigin);

nx = (1:length(xn)) - xorigin;
ny = (1:length(yn)) - yorigin;

mprintf("\nEXERCISE 3 - FOLD y(n) = x(-n)\n");
mprintf("xorigin = %d, yorigin = %d\n", xorigin, yorigin);
mprintf("Time indices of x(n):\n");
disp(nx);
mprintf("Samples xn:\n");
disp(xn);
mprintf("Time indices of y(n):\n");
disp(ny);
mprintf("Samples yn:\n");
disp(yn);

scf(3);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Exercise 3 - Fold";

subplot(2, 1, 1);
draw_signal_ex3(nx, xn, "Original signal x(n)", 2, "bo");

subplot(2, 1, 2);
draw_signal_ex3(ny, yn, "Folded signal y(n) = x(-n)", 5, "ro");


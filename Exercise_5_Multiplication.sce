// ============================================================================
// DSP LAB 3 - EXERCISE 5: POINTWISE MULTIPLICATION
// Function: [yn, yorigin] = multi(x1n, x1origin, x2n, x2origin)
// Operation: y(n) = x1(n) * x2(n)
//
// Signals are aligned on the union of their time-index supports. Missing samples
// are interpreted as zero. No numerical rounding is performed.
// ============================================================================

clear;
clc;
funcprot(0);

function [yn, yorigin] = multi(x1n, x1origin, x2n, x2origin)
    x1n = matrix(x1n, 1, length(x1n));
    x2n = matrix(x2n, 1, length(x2n));

    if (length(x1n) == 0) | (length(x2n) == 0) then
        error("Both input vectors must be non-empty.");
    end
    if (x1origin < 1) | (x1origin > length(x1n)) | (x1origin <> floor(x1origin)) then
        error("x1origin must be an integer from 1 to length(x1n).");
    end
    if (x2origin < 1) | (x2origin > length(x2n)) | (x2origin <> floor(x2origin)) then
        error("x2origin must be an integer from 1 to length(x2n).");
    end

    // Determine the actual time-index ranges of both inputs.
    n1_start = 1 - x1origin;
    n1_end   = length(x1n) - x1origin;
    n2_start = 1 - x2origin;
    n2_end   = length(x2n) - x2origin;

    // Construct their common index range.
    n_start = min([n1_start, n2_start]);
    n_end   = max([n1_end, n2_end]);
    common_n = n_start:n_end;

    // Zero-pad each input on the common index range.
    x1_aligned = zeros(1, length(common_n));
    x2_aligned = zeros(1, length(common_n));

    p1 = (n1_start - n_start + 1):(n1_end - n_start + 1);
    p2 = (n2_start - n_start + 1):(n2_end - n_start + 1);
    x1_aligned(p1) = x1n;
    x2_aligned(p2) = x2n;

    // Pointwise multiplication after time alignment.
    yn = x1_aligned .* x2_aligned;
    yorigin = 1 - n_start;
endfunction

// Align one signal to a requested common time range for plotting.
function aligned = align_for_plot_ex5(samples, origin, common_n)
    samples = matrix(samples, 1, length(samples));
    signal_n = (1:length(samples)) - origin;
    aligned = zeros(1, length(common_n));
    first_position = signal_n(1) - common_n(1) + 1;
    last_position  = signal_n($) - common_n(1) + 1;
    aligned(first_position:last_position) = samples;
endfunction

function draw_signal_ex5(n, samples, plot_title, color_style, marker_spec)
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
// x1 has support -2 <= n <= 1; x2 has support -1 <= n <= 2.
x1n = [1, -2, 3, 4];
x1origin = 3;
x2n = [2, 1, -1, 3];
x2origin = 2;

[yn, yorigin] = multi(x1n, x1origin, x2n, x2origin);
common_n = (1:length(yn)) - yorigin;
x1_plot = align_for_plot_ex5(x1n, x1origin, common_n);
x2_plot = align_for_plot_ex5(x2n, x2origin, common_n);

mprintf("\nEXERCISE 5 - MULTIPLICATION y(n) = x1(n) * x2(n)\n");
mprintf("Output origin yorigin = %d\n", yorigin);
mprintf("Common time indices:\n");
disp(common_n);
mprintf("Aligned x1(n):\n");
disp(x1_plot);
mprintf("Aligned x2(n):\n");
disp(x2_plot);
mprintf("Output y(n):\n");
disp(yn);

scf(5);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Exercise 5 - Multiplication";

subplot(3, 1, 1);
draw_signal_ex5(common_n, x1_plot, "First signal x1(n)", 2, "bo");

subplot(3, 1, 2);
draw_signal_ex5(common_n, x2_plot, "Second signal x2(n)", 3, "go");

subplot(3, 1, 3);
draw_signal_ex5(common_n, yn, "Product y(n) = x1(n) x2(n)", 5, "ro");


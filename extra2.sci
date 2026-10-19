// DSP LAB 3 - ADDITIONAL EXERCISE 2.2
// Generation of shifted, folded, gated, and symmetric sequences

clear;
clc;
funcprot(0);

function values = x_2_2(index)
    values = zeros(1, length(index));

    unit_region = find((index >= -1) & (index <= 2));
    if size(unit_region, "*") > 0 then
        values(unit_region) = 1;
    end

    half_region = find((index == 3) | (index == 4));
    if size(half_region, "*") > 0 then
        values(half_region) = 0.5;
    end
endfunction

function values = unit_step_2_2(index)
    values = bool2s(index >= 0);
endfunction

function values = unit_impulse_2_2(index)
    values = bool2s(index == 0);
endfunction

function draw_signal_2_2(n, samples, plot_title, ..
                         color_style, marker_spec)
    plot2d3(n, samples, color_style);
    stem_entity = gce();
    stem_entity.children.thickness = 3;

    plot(n, samples, marker_spec);
    marker_entity = gce();
    marker_entity.children.thickness = 2;
    marker_entity.children.mark_size = 5;

    axes_handle = gca();
    axes_handle.x_location = "origin";
    axes_handle.y_location = "left";
    axes_handle.grid = [1 1];
    axes_handle.box = "on";

    ymin = min([samples 0]);
    ymax = max([samples 0]);
    ypad = max([0.35, 0.18 * (ymax-ymin+1)]);
    axes_handle.data_bounds = ..
        [min(n)-1, ymin-ypad; max(n)+1, ymax+ypad];
    xtitle(plot_title, "Sample index n", "Amplitude");
endfunction

n = -8:8;

ya = x_2_2(n - 2);
yb = x_2_2(4 - n);
yc = x_2_2(n + 2);
yd = x_2_2(n) .* unit_step_2_2(2 - n);
ye = x_2_2(n - 1) .* unit_impulse_2_2(n - 3);
yf = x_2_2(n.^2);
xe = 0.5 * (x_2_2(n) + x_2_2(-n));
xo = 0.5 * (x_2_2(n) - x_2_2(-n));

reconstruction_error = max(abs(x_2_2(n) - xe - xo));
even_symmetry_error = max(abs(xe - xe($:-1:1)));
odd_symmetry_error = max(abs(xo + xo($:-1:1)));

mprintf("\nADDITIONAL EXERCISE 2.2\n");
mprintf("max|x - xe - xo| = %.16g\n", reconstruction_error);
mprintf("max|xe(n) - xe(-n)| = %.16g\n", even_symmetry_error);
mprintf("max|xo(n) + xo(-n)| = %.16g\n", odd_symmetry_error);
mprintf("Part (e): x(n-1)delta(n-3) = delta(n-3), since x(2)=1.\n");

scf(22);
clf();
figure_handle = gcf();
figure_handle.figure_name = ..
    "Lab 3 - Additional Exercise 2.2";

subplot(4, 2, 1);
draw_signal_2_2(n, ya, "(a) x(n-2)", 2, "bo");
subplot(4, 2, 2);
draw_signal_2_2(n, yb, "(b) x(4-n)", 5, "ro");
subplot(4, 2, 3);
draw_signal_2_2(n, yc, "(c) x(n+2)", 3, "go");
subplot(4, 2, 4);
draw_signal_2_2(n, yd, "(d) x(n)u(2-n)", 6, "mo");
subplot(4, 2, 5);
draw_signal_2_2(n, ye, "(e) x(n-1)delta(n-3)", 4, "co");
subplot(4, 2, 6);
draw_signal_2_2(n, yf, "(f) x(n^2)", 5, "ro");
subplot(4, 2, 7);
draw_signal_2_2(n, xe, "(g) Even part of x(n)", 2, "bo");
subplot(4, 2, 8);
draw_signal_2_2(n, xo, "(h) Odd part of x(n)", 3, "go");

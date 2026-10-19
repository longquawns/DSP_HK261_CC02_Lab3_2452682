// ============================================================================
// DSP LAB 3 - ADDITIONAL EXERCISE 2.1
// Composition of folding and shifting operations
//
// Given:
//             1 + n/3,  -3 <= n <= -1
//   x(n) =    1,         0 <= n <= 3
//             0,         elsewhere
//
// No numerical rounding is performed.
// ============================================================================

clear;
clc;
funcprot(0);

// Evaluate x(n) for any vector of integer indices.
function values = x_2_1(index)
    values = zeros(1, length(index));

    first_region = find((index >= -3) & (index <= -1));
    if size(first_region, "*") > 0 then
        values(first_region) = 1 + index(first_region) / 3;
    end

    second_region = find((index >= 0) & (index <= 3));
    if size(second_region, "*") > 0 then
        values(second_region) = 1;
    end
endfunction

function draw_signal_2_1(n, samples, plot_title, color_style, marker_spec)
    plot2d3(n, samples, color_style);
    stem_entity = gce();
    stem_entity.children.thickness = 3;

    // Add an unfilled circle at each discrete-time sample.
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
    ypad = max([0.40, 0.18 * (ymax - ymin + 1)]);
    axes_handle.data_bounds = [min(n)-1, ymin-ypad; max(n)+1, ymax+ypad];
    xtitle(plot_title, "Sample index n", "Amplitude");
endfunction

// Use a sufficiently wide finite plotting interval. The formulas below evaluate
// the corresponding infinite discrete-time signals exactly on this interval.
n = -8:8;

// (a) Original signal.
xn = x_2_1(n);

// (b.1) Fold first, then delay by four samples:
//        x_f(n)=x(-n), y_b1(n)=x_f(n-4)=x(4-n).
yb1 = x_2_1(4 - n);

// (b.2) Delay first, then fold:
//        x_d(n)=x(n-4), y_b2(n)=x_d(-n)=x(-n-4).
yb2 = x_2_1(-n - 4);

// (c) Direct evaluation of x(-n+4)=x(4-n).
yc = x_2_1(-n + 4);

// (e) Exact impulse/step representation:
// x(n) = (1/3)delta(n+2) + (2/3)delta(n+1) + u(n) - u(n-4).
delta_n_plus_2 = bool2s(n == -2);
delta_n_plus_1 = bool2s(n == -1);
unit_n = bool2s(n >= 0);
unit_n_minus_4 = bool2s(n >= 4);
x_reconstructed = (1/3) * delta_n_plus_2 + ..
                  (2/3) * delta_n_plus_1 + unit_n - unit_n_minus_4;

// Numerical checks use full precision; no rounded intermediate values are used.
composition_error = max(abs(yb1 - yc));
reconstruction_error = max(abs(xn - x_reconstructed));

mprintf("\nADDITIONAL EXERCISE 2.1\n");
mprintf("Nonzero values of x(n):\n");
for sample_index = -2:3
    mprintf("x(%d) = %.12g\n", sample_index, x_2_1(sample_index));
end
mprintf("\nmax|fold-then-delay - x(-n+4)| = %.16g\n", composition_error);
mprintf("max|x - impulse/step reconstruction| = %.16g\n", reconstruction_error);
mprintf("\nRule: x(-n+k) is obtained by folding x(n) first, then delaying by k.\n");
mprintf("Delay first and fold afterward gives x(-n-k), which is different.\n");

scf(21);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Additional Exercise 2.1";

subplot(3, 2, 1);
draw_signal_2_1(n, xn, "(a) Original x(n)", 2, "bo");

subplot(3, 2, 2);
draw_signal_2_1(n, yb1, "(b.1) Fold, then delay 4: x(4-n)", 5, "ro");

subplot(3, 2, 3);
draw_signal_2_1(n, yb2, "(b.2) Delay 4, then fold: x(-n-4)", 3, "go");

subplot(3, 2, 4);
draw_signal_2_1(n, yc, "(c) Direct signal x(-n+4)", 6, "mo");

subplot(3, 2, 5);
draw_signal_2_1(n, x_reconstructed, "(e) Reconstruction using delta and u", 4, "co");

subplot(3, 2, 6);
draw_signal_2_1(n, yb1-yc, "Verification: x(4-n) results are identical", 1, "ko");


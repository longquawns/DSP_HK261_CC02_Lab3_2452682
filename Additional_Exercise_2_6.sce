// ============================================================================
// DSP LAB 3 - ADDITIONAL EXERCISE 2.6
// Time-invariance tests for three discrete-time systems
//
// Input signal: x(n)=1 for 0 <= n <= 3 and x(n)=0 elsewhere.
// Delay used by the exercise: n0 = 2 samples.
// No numerical rounding is performed.
// ============================================================================

clear;
clc;
funcprot(0);

function values = x_2_6(index)
    values = bool2s((index >= 0) & (index <= 3));
endfunction

function draw_signal_2_6(n, samples, plot_title, color_style, marker_spec)
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
    ypad = max([0.75, 0.18 * (ymax - ymin + 1)]);
    axes_handle.data_bounds = [min(n)-1, ymin-ypad; max(n)+1, ymax+ypad];
    xtitle(plot_title, "Sample index n", "Amplitude");
endfunction

n = -6:8;
n0 = 2;
x = x_2_6(n);
x_delayed = x_2_6(n - n0);

// ---------------------------------------------------------------------------
// (a)-(b) System A: T_A{x(n)} = x(n^2)
// ---------------------------------------------------------------------------
yA = x_2_6(n.^2);

// Delay the original output: y_A(n-n0)=x((n-n0)^2).
yA_delayed = x_2_6((n - n0).^2);

// Apply T_A to delayed input x_2(n)=x(n-n0):
// T_A{x_2}(n)=x_2(n^2)=x(n^2-n0).
yA_from_delayed_input = x_2_6(n.^2 - n0);
error_A = max(abs(yA_from_delayed_input - yA_delayed));

// ---------------------------------------------------------------------------
// (c) System B: T_B{x(n)} = x(n) - x(n-1)
// ---------------------------------------------------------------------------
yB = x_2_6(n) - x_2_6(n - 1);

// Delay the original output by n0.
yB_delayed = x_2_6(n - n0) - x_2_6(n - n0 - 1);

// Apply T_B to delayed input x_2(n)=x(n-n0).
yB_from_delayed_input = x_delayed - x_2_6(n - n0 - 1);
error_B = max(abs(yB_from_delayed_input - yB_delayed));

// ---------------------------------------------------------------------------
// (d) System C: T_C{x(n)} = n*x(n)
// ---------------------------------------------------------------------------
yC = n .* x;

// Delay the original output: y_C(n-n0)=(n-n0)x(n-n0).
yC_delayed = (n - n0) .* x_2_6(n - n0);

// Apply T_C to the delayed input: T_C{x_2}(n)=n*x(n-n0).
yC_from_delayed_input = n .* x_delayed;
error_C = max(abs(yC_from_delayed_input - yC_delayed));

// ------------------------------- Console output ----------------------------
mprintf("\nADDITIONAL EXERCISE 2.6 - TIME-INVARIANCE TESTS\n");
mprintf("Delay n0 = %d samples\n", n0);
mprintf("\nSystem A: T{x}(n)=x(n^2)\n");
mprintf("max|T{x(n-n0)} - y(n-n0)| = %.16g -> NOT time-invariant\n", error_A);
mprintf("\nSystem B: T{x}(n)=x(n)-x(n-1)\n");
mprintf("max|T{x(n-n0)} - y(n-n0)| = %.16g -> time-invariant\n", error_B);
mprintf("\nSystem C: T{x}(n)=n*x(n)\n");
mprintf("max|T{x(n-n0)} - y(n-n0)| = %.16g -> NOT time-invariant\n", error_C);

// ------------------------------- Figure A ----------------------------------
scf(26);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Problem 2.6 - System x(n^2)";

subplot(3, 2, 1);
draw_signal_2_6(n, x, "(b1) Input x(n)", 2, "bo");

subplot(3, 2, 2);
draw_signal_2_6(n, yA, "(b2) y(n) = x(n^2)", 5, "ro");

subplot(3, 2, 3);
draw_signal_2_6(n, yA_delayed, "(b3) y(n-2)", 3, "go");

subplot(3, 2, 4);
draw_signal_2_6(n, x_delayed, "(b4) x2(n) = x(n-2)", 6, "mo");

subplot(3, 2, 5);
draw_signal_2_6(n, yA_from_delayed_input, "(b5) T{x2}(n) = x2(n^2)", 4, "co");

subplot(3, 2, 6);
draw_signal_2_6(n, yA_from_delayed_input-yA_delayed, ..
                "(b6) Difference proves time variance", 1, "ko");

// ------------------------------- Figure B ----------------------------------
scf(27);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Problem 2.6 - Difference System";

subplot(2, 2, 1);
draw_signal_2_6(n, yB, "(c) y(n) = x(n)-x(n-1)", 2, "bo");

subplot(2, 2, 2);
draw_signal_2_6(n, yB_delayed, "Delayed output y(n-2)", 5, "ro");

subplot(2, 2, 3);
draw_signal_2_6(n, yB_from_delayed_input, "Output from delayed input T{x2}", 3, "go");

subplot(2, 2, 4);
draw_signal_2_6(n, yB_from_delayed_input-yB_delayed, ..
                "Zero difference: time-invariant", 1, "ko");

// ------------------------------- Figure C ----------------------------------
scf(28);
clf();
figure_handle = gcf();
figure_handle.figure_name = "Lab 3 - Problem 2.6 - System n x(n)";

subplot(2, 2, 1);
draw_signal_2_6(n, yC, "(d) y(n) = n x(n)", 2, "bo");

subplot(2, 2, 2);
draw_signal_2_6(n, yC_delayed, "Delayed output y(n-2)", 5, "ro");

subplot(2, 2, 3);
draw_signal_2_6(n, yC_from_delayed_input, "Output from delayed input T{x2}", 3, "go");

subplot(2, 2, 4);
draw_signal_2_6(n, yC_from_delayed_input-yC_delayed, ..
                "Nonzero difference: time-varying", 1, "ko");


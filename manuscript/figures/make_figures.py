"""Generate the three figures for rho_mf_derivation.tex."""

import numpy as np
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.size": 11,
    "axes.labelsize": 12,
    "axes.titlesize": 12,
    "legend.fontsize": 10,
    "figure.dpi": 150,
    "savefig.bbox": "tight",
    "text.usetex": False,  # keep portable
})

alpha = np.linspace(0, 1, 401)


def kappa_walid(a):
    return 2 - a


def kappa_A(a):
    return 1 + (1 - a) ** 2


def kappa_B(a):
    return 2 * (1 - a + a ** 2)


def rho_out(a, VA, model="B"):
    B = (1 - a) ** 2 + (a ** 2 if model == "B" else 0.0)
    return (1 - a) * np.sqrt((1 + 2 * VA) / (1 + 2 * VA * B))


# ----- Figure 1: rho_mf^(out) vs alpha at several V_A (Model B) -----
fig, ax = plt.subplots(figsize=(5.6, 4.0))
VA_values = [0.0, 0.1, 0.5, 1.0]
colors = plt.cm.viridis(np.linspace(0.15, 0.85, len(VA_values)))
for VA, c in zip(VA_values, colors):
    ax.plot(alpha, rho_out(alpha, VA, model="B"),
            color=c, lw=2, label=fr"$V_A = {VA}$")
ax.plot(alpha, 1 - alpha, color="black", ls=":", lw=1.5,
        label=r"$1-\alpha$ (draft's claim)")
ax.set_xlabel(r"EPP rate $\alpha$")
ax.set_ylabel(r"$\rho^{(\mathrm{out})}_{mf}$")
ax.set_title(r"Realized output correlation between mates (Model B)")
ax.set_xlim(0, 1)
ax.set_ylim(0, 1.02)
ax.legend(loc="upper right", frameon=False)
ax.grid(alpha=0.25)
fig.savefig("rho_out_vs_alpha.pdf")
plt.close(fig)


# ----- Figure 2: kappa(alpha) comparison -----
fig, ax = plt.subplots(figsize=(5.6, 4.0))
ax.axvspan(0, 0.3, color="0.92", zorder=0, label="empirical EPP range")
ax.plot(alpha, kappa_B(alpha), color="C0", lw=2.2,
        label=r"Model B: $2(1-\alpha+\alpha^2)$")
ax.plot(alpha, kappa_A(alpha), color="C1", lw=2.2, ls="--",
        label=r"Model A: $1 + (1-\alpha)^2$")
ax.plot(alpha, kappa_walid(alpha), color="C3", lw=1.8, ls=":",
        label=r"draft: $2-\alpha$")
# mark the agreement points
for a_pt in [0.0, 0.5]:
    ax.plot(a_pt, kappa_walid(a_pt), "ko", ms=4, zorder=5)
ax.plot(1.0, kappa_A(1.0), "ko", ms=4, zorder=5)
ax.set_xlabel(r"EPP rate $\alpha$")
ax.set_ylabel(r"mating-system scalar $\kappa(\alpha)$")
ax.set_title(r"Coefficient of $V_A$ in $N_e/N = 1/(1+\kappa V_A)$")
ax.set_xlim(0, 1)
ax.set_ylim(0.9, 2.05)
ax.legend(loc="upper right", frameon=False)
ax.grid(alpha=0.25)
fig.savefig("kappa_comparison.pdf")
plt.close(fig)


# ----- Figure 3: N_e/N vs alpha at two V_A values -----
fig, axes = plt.subplots(1, 2, figsize=(9.2, 4.0), sharey=False)
for ax, VA in zip(axes, [0.3, 1.0]):
    ax.axvspan(0, 0.3, color="0.92", zorder=0)
    ne_walid = 1.0 / (1.0 + kappa_walid(alpha) * VA)
    ne_A = 1.0 / (1.0 + kappa_A(alpha) * VA)
    ne_B = 1.0 / (1.0 + kappa_B(alpha) * VA)
    ax.plot(alpha, ne_B, color="C0", lw=2.2, label="Model B")
    ax.plot(alpha, ne_A, color="C1", lw=2.2, ls="--", label="Model A")
    ax.plot(alpha, ne_walid, color="C3", lw=1.8, ls=":", label="draft ($2-\\alpha$)")
    ax.set_xlabel(r"EPP rate $\alpha$")
    ax.set_ylabel(r"$N_e / N$")
    ax.set_title(fr"$V_A = {VA}$")
    ax.set_xlim(0, 1)
    ax.grid(alpha=0.25)
axes[0].legend(loc="lower right", frameon=False)
fig.suptitle("Predicted $N_e/N$ across EPP rate (single-chromosome unlinked baseline)",
             y=1.02)
fig.savefig("ne_ratio.pdf")
plt.close(fig)

print("wrote rho_out_vs_alpha.pdf, kappa_comparison.pdf, ne_ratio.pdf")

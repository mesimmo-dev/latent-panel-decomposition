### `latent_panel_decomposition.do`
```stata
clear all
set more off
set seed 7319

set obs 500

gen id = ceil(_n / 10)
bysort id: gen t = _n

gen alpha = rnormal()
bysort id: replace alpha = alpha[1]

gen x1 = rnormal()
gen x2 = 0.45*x1 + rnormal()
gen eps = rnormal(0, 0.8)

gen y = 1.2*x1 - 0.6*x2 + alpha + eps

xtset id t

bysort id: egen mean_y  = mean(y)
bysort id: egen mean_x1 = mean(x1)
bysort id: egen mean_x2 = mean(x2)

gen within_y  = y  - mean_y
gen within_x1 = x1 - mean_x1
gen within_x2 = x2 - mean_x2

xtreg y x1 x2, fe

predict residual, e
predict fitted, xb

gen residual_sq = residual^2

collapse ///
    (mean) mean_residual=residual ///
    (sd) sd_residual=residual ///
    (mean) residual_variance=residual_sq, ///
    by(id)

summarize mean_residual sd_residual residual_variance

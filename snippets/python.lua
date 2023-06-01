--[[
snippet divider "print divider" bA
print("=" * 80)
endsnippet

snippet jcel "new jupyter cell" bA
# %%
endsnippet

snippet %% "new jupyter cell" bA
# %%
endsnippet

snippet md% "new markdown cell" bA
# %% [markdown]
#
endsnippet

snippet printhead "print DataFrame head" bA
with pd.option_context("display.max_columns", None), pd.option_context("display.width", None), pd.option_context("display.max_colwidth", None):  # type: ignore
	print(df.head())
endsnippet


snippet syspath "append to system path" bA
import sys

sys.path.extend([".", ".."])
endsnippet

snippet aiimports "" bA
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import plotly.express as px
import torch
import torch.nn as nn
import torch.nn.functional as F
endsnippet

snippet debug "debug with ipy" bA
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
from IPython import embed   # type: ignore

embed()
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
endsnippet
]]
return {
    s("cell", t("# %%")),
    s("ifmain", t('if __name__ == "__main__":')),
}
